#include <stdlib.h>
#include <stdbool.h>


// global variable
volatile int pixel_buffer_start; 

// declaration of functions
void clear_screen();
void plot_pixel(int x, int y, short int line_colour);
void draw_line(int x0, int y0, int x1, int y1, short int colour);
void swap(int* one, int* two);

// main
int main(void)
{
	
    volatile int * pixel_ctrl_ptr = (int *)0xFF203020;

    /* Read location of the pixel buffer from the pixel buffer controller */
    pixel_buffer_start = *pixel_ctrl_ptr;

    // clear screen by setting all pixels to black and draw lines
    clear_screen();
    draw_line(0, 0, 150, 150, 0x001F);   // this line is blue
    draw_line(150, 150, 319, 0, 0x07E0); // this line is green
    draw_line(0, 239, 319, 239, 0xF800); // this line is red
    draw_line(319, 0, 0, 239, 0xF81F);   // this line is a pink colour

    // end main
    return 0;
}

// code not shown for clear_screen() and draw_line() subroutines


// function to plot pixel given a point and colout
void plot_pixel(int x, int y, short int line_colour)
{
	// creates 32 bit address based off of x and y coordinates
	// adds address to pixel buffer start to get address of specific pixel and fills colour
    *(short int *)(pixel_buffer_start + (y << 10) + (x << 1)) = line_colour;
}

// function to draw line given two points and colour
void draw_line(int x0, int y0, int x1, int y1, short int colour){

	// follow alg
	bool is_steep;
	
	// test to see if its steep
	if(abs(y1-y0)> abs(x1-x0)){
		is_steep=true;
	}
	else{
		is_steep=false;
	}

	// If steep, follow alg swaps
	if(is_steep==true){
		swap(&x0,&y0);
		swap(&x1,&y1);
	}

	// Follow alg swap conditions
	if(x0>x1){
		swap(&x0,&x1);
		swap(&y0,&y1);
	}

	// declaration of variables
	int deltax= x1-x0;
	int deltay= abs(y1-y0);
	int error= -(deltax/2);
	int y_step;
	int y= y0;

	// direction of y point
	if (y0<y1){
		y_step=1;
	}
	else{
		y_step=-1;
	}

	int x;

	// Goes through all x points from x0 to x1
	for (x=x0; x<x1+1; ++x){

		// If steep, plot pixel
		if (is_steep==true){
			plot_pixel(y,x,colour);
		}

		// if not steep, plot normally with error
		else{
			plot_pixel(x,y,colour);
			error=error +deltay;
		}

		// Account for change in drawing due to error
		if (error >= 0){
			y=y+y_step;
			error= error -deltax;
		}
	}
}

// function to clear screen
void clear_screen(){

	// Goes through all x and y pixels and sets to black
	for (int x=0; x<320; ++x){
		for (int y=0; y<240; ++y){
			plot_pixel(x,y,0x0000);
		}
			
	}
}

// function to swap two points
void swap(int* one, int* two){
	int temp=*one;
	*one=*two;
	*two=temp;
}
