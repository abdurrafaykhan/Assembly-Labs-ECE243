#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

// global variable
volatile int pixel_buffer_start; 

// declaration of functions
void clear_screen();
void draw_line(int x0, int y0, int x1, int y1, short int line_color);
void plot_pixel(int x, int y, short int line_color);
void swap(int *a, int* b);
void wait_for_vsync();
void draw_box(int x, int y, short int color);

// main
int main(void)
{   
    // sets buffer register address
    volatile int * pixel_ctrl_ptr = (int *)0xFF203020;
    
    // Creates array for location and direction of 8 points
    int xBoxLocation[8];
    int yBoxLocation[8];
    int dxBox[8];
    int dyBox[8];

    // colours - green for points, pink for lines
    short int GREEN = 0x07E0; 
    short int PINK = 0xF81F;  

    // Store random starting points and directions
    for (int i = 0; i< 8; ++i){

        // points are inbetween 0 and and 317 for x and 0 and 237 for y
        xBoxLocation[i] = rand() % 318;       
        yBoxLocation[i] = rand() % 238;

        // sets random change in x and y direction to +10 or -10       
        dxBox[i] = (rand() % 2 * 2 - 1)*10;   
        dyBox[i] = (rand() % 2 * 2 - 1)*10;   
    }

    /* set front pixel buffer to start of FPGA On-chip memory */
    *(pixel_ctrl_ptr + 1) = 0xC8000000; // first store the address in the 
                                        // back buffer

    /* now, swap the front/back buffers, to set the front buffer location */
    wait_for_vsync();

    /* initialize a pointer to the pixel buffer, used by drawing functions */
    pixel_buffer_start = *pixel_ctrl_ptr;

    clear_screen(); // pixel_buffer_start points to the pixel buffer

    /* set back pixel buffer to start of SDRAM memory */
    *(pixel_ctrl_ptr + 1) = 0xC0000000;

    pixel_buffer_start = *(pixel_ctrl_ptr + 1); // we draw on the back buffer

    // infinite loop
    while (1)
    {
        // Clears screen before drawing again
        clear_screen();

        // draw all boxes and connect lines
        for (int i = 0; i < 8; ++i){
            draw_box(xBoxLocation[i], yBoxLocation[i], GREEN);
            draw_line(xBoxLocation[i], yBoxLocation[i], xBoxLocation[(i+1)%8], yBoxLocation[(i+1)%8], PINK);
        }

        // get new box locations and directions
        for (int i = 0; i< 8; ++i) {

            // adds the change in x and y
            xBoxLocation[i] += dxBox[i];
            yBoxLocation[i] += dyBox[i];

            // if at the left boundary or right boundary, switch directions
            if (xBoxLocation[i] < 0 || xBoxLocation[i] > 317){
                    dxBox[i] = -dxBox[i];
                    xBoxLocation[i] += dxBox[i];
            }

            // if at the top or bottom boundary, switch directions
            if (yBoxLocation[i] < 0 || yBoxLocation[i] > 237){
                dyBox[i] = -dyBox[i];
                yBoxLocation[i] += dyBox[i];
            }
        }

        wait_for_vsync(); // swap front and back buffers on VGA vertical sync
        pixel_buffer_start = *(pixel_ctrl_ptr + 1); // new back buffer
    }
}

// function to draw 3x3 box
void draw_box(int x, int y, short int color){

    // go through 9 pixels and fill
    for(int i = y; i <= y+2 ; ++i)
        for (int j = x; j <= x+2 ; ++j)
        plot_pixel(j, i, color);
}   

// Drawing black everywhere on screen
void clear_screen(){
    for (int x = 0; x < 320; ++x){
        for (int y = 0; y < 240; ++y){
                plot_pixel(x, y, 0x0000);
        }
    }
}

// Function that draws a line using Bresenhamâ€™s algorithm
void draw_line(int x0, int y0, int x1, int y1, short int line_color)
{
    // follow steep algorithm to draw line given two poitns and colour
    bool is_steep = abs(y1 - y0) > abs(x1 - x0);
    if (is_steep){
        swap(&x0, &y0);
        swap(&x1, &y1);
    }
    if (x0 > x1) {
        swap(&x0, &x1);
        swap(&y0, &y1);
    }
    
    int deltax = x1 - x0;
    int deltay = abs(y1 - y0);
    int error = -(deltax / 2);
    int y = y0;
    int y_step = 0;
    if (y0 < y1) {
        y_step = 1;
    } else {
        y_step = -1;
    }

    for (int x = x0; x <= x1; ++x){
        if (is_steep) {
            plot_pixel(y, x, line_color);
        } else {
            plot_pixel(x, y, line_color);
        }
            error = error + deltay;
        if (error >= 0){
            y = y + y_step;
            error = error - deltax;
        }
    }
}

// function to swap two points
void swap(int* a, int* b)
{
    int temp = *a;
    *a = *b;
    *b = temp;
}

// Function to plot a pixel with a given colour
void plot_pixel(int x, int y, short int line_color)
{
    *(short int *)(pixel_buffer_start + (y << 10) + (x << 1)) = line_color;
}

// function to wait for the screen to be drawn before proceeding
void wait_for_vsync() {

    // pixel controller
    volatile int * pixel_ctrl_ptr = (int*)0xFF203020; 
    register int status; 

    // Start the synchronization process
    *pixel_ctrl_ptr = 1; 

    // status will be 0 when at the end
    status = *(pixel_ctrl_ptr + 3);
    while ((status & 0x01) != 0) {
         status = *(pixel_ctrl_ptr +3);
    }
}


