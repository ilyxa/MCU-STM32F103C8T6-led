#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>

static void clock_setup(void)
{
	rcc_clock_setup_in_hsi_out_64mhz();
	rcc_periph_clock_enable(RCC_AFIO);
	rcc_periph_clock_enable(RCC_GPIOC); // GPIOC!!!!
}

static void gpio_setup(void)
{

	AFIO_MAPR |= AFIO_MAPR_SWJ_CFG_FULL_SWJ_NO_JNTRST;
	
	gpio_set_mode(GPIOC, GPIO_MODE_OUTPUT_2_MHZ, // GPIOC!!!
		      GPIO_CNF_OUTPUT_PUSHPULL,GPIO13);
	
}

int main(void)
{
	int i;

	clock_setup();
	gpio_setup();

	while (1) { 
		gpio_toggle(GPIOC, GPIO13);	/* LED on/off */ // GPIOC!!!!
		for (i = 0; i < 8000000; i++)	/* Wait a bit. */
			__asm__("nop");
	}

	return 0;
}
