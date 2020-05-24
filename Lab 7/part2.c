#include <stdbool.h>

// declaration of variables
void wait_for_vsync();
void draw_line(int x0, int x1, int y, short int colour);
void draw_line_up();
void clear_screen();
void plot_pixel(int x, int y, short int line_color);

// declarationof pixel buffer
volatile int pixel_buffer_start;

// main
int main(void){

	// sets to buffer register
	volatile int * pixel_ctrl_ptr = (int *)0xFF203020;
	pixel_buffer_start=*pixel_ctrl_ptr;

	// clears screen with all black
	clear_screen();

	// declare boundaries of screen
	int x0 = 120;
	int x1 = 180;
	int y = 0;
	int ymax = 239;

	// direction determines if going up or down
	bool direction=true; 

	// infinite loop
	while(1){
		
		// true = going down
		if(direction==true){

			// draw line, wait for sync, erase by drawing black line
			draw_line(x0,x1,y,0xFFFF);
			wait_for_vsync();
			draw_line(x0,x1,y,0x0000);

			// if at the bottom, switch directions and stay in the same spot
			if (y==ymax){
				direction=false;
				y=y-1;
			}
			// go down one pixel
			y=y+1;
		}

		// false = going up
		if(direction==false){

			// draw line, wait for sync, erase by drawing black line
			draw_line(x0,x1,y,0xFFFF);
			wait_for_vsync();
			draw_line(x0,x1,y,0x0000);

			// if at the top, switch directions and stay in the same spot
			if(y==0){
				direction=true;
				y=y+1; 
			}
			// go up one pixel
			y=y-1;
		}

	}

}

// function to sync entire screen
void wait_for_vsync(){

	// buffer register
	volatile int *pixel_ctr_ptr= (int*)0xFF203020;
	register int status;

	*pixel_ctr_ptr=1; // start sync process
	
	// status equals 0 when full screen done
	status = *(pixel_ctr_ptr + 3);
	while ((status & 0x01) !=0){
		status= *(pixel_ctr_ptr +3);
	}
}

// function to plot a pixel
void plot_pixel(int x, int y, short int line_color){
    *(short int *)(pixel_buffer_start + (y << 10) + (x << 1)) = line_color;
}

// function to draw a line
void draw_line(int x0, int x1, int y, short int colour){
		
	// go through all x points for that line, y stays same, plot
	for(int x=x0;x<x1+1; ++x){
		plot_pixel(x,y,colour);
	}
}

// function to clear screen
void clear_screen(){
	for (int x=0; x<320; ++x){
		for (int y=0; y<240; ++y){
			plot_pixel(x,y,0x0000);
		}	
	}
}