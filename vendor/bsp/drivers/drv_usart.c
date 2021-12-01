/*
 * Copyright (c) 2006-2021, RT-Thread Development Team
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author            Notes
 * 2021-01-04     iysheng           first version
 */

#include <drv_usart.h>
#include <board.h>

#ifdef RT_USING_SERIAL

#if !defined(BSP_USING_UART0) && !defined(BSP_USING_UART1) && \
    !defined(BSP_USING_UART2) && !defined(BSP_USING_UART3) && \
    !defined(BSP_USING_UART4)
    #error "Please define at least one UARTx"

#endif

#include <rtdevice.h>

static void uart_isr(struct rt_serial_device *serial);

#if defined(BSP_USING_UART0)
struct rt_serial_device serial0;

void USART0_IRQHandler(void)
{
    /* enter interrupt */
    rt_interrupt_enter();

    uart_isr(&serial0);

    /* leave interrupt */
    rt_interrupt_leave();
}

#endif /* BSP_USING_UART0 */

#if defined(BSP_USING_UART1)
struct rt_serial_device serial1;

void USART1_IRQHandler(void)
{
    /* enter interrupt */
    rt_interrupt_enter();

    uart_isr(&serial1);

    /* leave interrupt */
    rt_interrupt_leave();
}

#endif /* BSP_USING_UART1 */

#if defined(BSP_USING_UART2)
struct rt_serial_device serial2;

void USART2_IRQHandler(void)
{
    /* enter interrupt */
    rt_interrupt_enter();

    uart_isr(&serial2);

    /* leave interrupt */
    rt_interrupt_leave();
}

#endif /* BSP_USING_UART2 */

#if defined(BSP_USING_UART3)
struct rt_serial_device serial3;

void UART3_IRQHandler(void)
{
    /* enter interrupt */
    rt_interrupt_enter();

    uart_isr(&serial3);

    /* leave interrupt */
    rt_interrupt_leave();
}

#endif /* BSP_USING_UART3 */

#if defined(BSP_USING_UART4)
struct rt_serial_device serial4;

void UART4_IRQHandler(void)
{
    /* enter interrupt */
    rt_interrupt_enter();

    uart_isr(&serial4);

    /* leave interrupt */
    rt_interrupt_leave();
}
#endif /* BSP_USING_UART4 */

static const struct gd32_uart uarts[] = {
#ifdef BSP_USING_UART0
    {
        USART0,                             /* uart peripheral index */
        USART0_IRQn,                        /* uart iqrn */
        RCU_USART0, RCU_GPIOA, RCU_GPIOA,   /* periph clock, tx gpio clock, rt gpio clock */
        GPIOA, GPIOA,                       /* tx port, tx alternate, tx pin */
        GPIO_PIN_9, GPIO_PIN_10,            /* rx port, rx alternate, rx pin */
        &serial0,
        "uart0",
    },
#endif

#ifdef BSP_USING_UART1
    {
        USART1,                             /* uart peripheral index */
        USART1_IRQn,                        /* uart iqrn */
        RCU_USART1, RCU_GPIOA, RCU_GPIOA,   /* periph clock, tx gpio clock, rt gpio clock */
        GPIOA, GPIOA,                       /* tx port, tx alternate, tx pin */
        GPIO_PIN_2, GPIO_PIN_3,             /* rx port, rx alternate, rx pin */
        &serial1,
        "uart1",
    },
#endif

#ifdef BSP_USING_UART2
    {
        USART2,                             /* uart peripheral index */
        USART2_IRQn,                        /* uart iqrn */
        RCU_USART2, RCU_GPIOB, RCU_GPIOB,   /* periph clock, tx gpio clock, rt gpio clock */
        GPIOB, GPIOB,                       /* tx port, tx alternate, tx pin */
        GPIO_PIN_10, GPIO_PIN_11,           /* rx port, rx alternate, rx pin */
        &serial2,
        "uart2",
    },
#endif

#ifdef BSP_USING_UART3
    {
        UART3,                              /* uart peripheral index */
        UART3_IRQn,                         /* uart iqrn */
        RCU_UART3, RCU_GPIOC, RCU_GPIOC,    /* periph clock, tx gpio clock, rt gpio clock */
        GPIOC, GPIOC,                       /* tx port, tx alternate, tx pin */
        GPIO_PIN_10, GPIO_PIN_11,           /* rx port, rx alternate, rx pin */
        &serial3,
        "uart3",
    },
#endif

#ifdef BSP_USING_UART4
    {
        UART4,                              /* uart peripheral index */
        UART4_IRQn,                         /* uart iqrn */
        RCU_UART4, RCU_GPIOC, RCU_GPIOD,    /* periph clock, tx gpio clock, rt gpio clock */
        GPIOC, GPIOD,                       /* tx port, tx alternate, tx pin */
        GPIO_PIN_12, GPIO_PIN_2,            /* rx port, rx alternate, rx pin */
        &serial4,
        "uart4",
    },
#endif
};

/**
* @brief UART MSP Initialization
*        This function configures the hardware resources used in this example:
*           - Peripheral's clock enable
*           - Peripheral's GPIO Configuration
*           - NVIC configuration for UART interrupt request enable
* @param huart: UART handle pointer
* @retval None
*/
void gd32_uart_gpio_init(struct gd32_uart *uart)
{
    /* enable USART clock */
    rcu_periph_clock_enable(uart->tx_gpio_clk);
    rcu_periph_clock_enable(uart->rx_gpio_clk);
    rcu_periph_clock_enable(uart->per_clk);

    uint32_t port = uart->tx_port;
    uint32_t gpio_pin = uart->tx_pin;
    uint32_t GPIO_Mode = GPIO_MODE_AF_PP;
    gpio_init(port,GPIO_Mode,GPIO_OSPEED_50MHZ,gpio_pin);

    /* TODO 初始化 RX */
    port = uart->rx_port;
    gpio_pin = uart->rx_pin;
    GPIO_Mode = GPIO_MODE_IN_FLOATING;
    gpio_init(port,GPIO_Mode,GPIO_OSPEED_50MHZ,gpio_pin);

    NVIC_SetPriority(uart->irqn, 0);
    NVIC_EnableIRQ(uart->irqn);
}

static rt_err_t gd32_configure(struct rt_serial_device *serial, struct serial_configure *cfg)
{
    struct gd32_uart *uart;

    RT_ASSERT(serial != RT_NULL);
    RT_ASSERT(cfg != RT_NULL);

    uart = (struct gd32_uart *)serial->parent.user_data;
    gd32_uart_gpio_init(uart);

    uint32_t USARTx = uart->uart_periph;
    uint32_t baudval = cfg->baud_rate;
    uint32_t wlen = (cfg->data_bits == DATA_BITS_9)?USART_WL_9BIT:USART_WL_8BIT;
    uint32_t stblen = (cfg->stop_bits == STOP_BITS_2)?USART_STB_2BIT:USART_STB_1BIT;
    uint32_t paritycfg = USART_PM_NONE;

    switch (cfg->parity) {
    case PARITY_ODD:
        paritycfg = USART_PM_ODD;
        break;
    case PARITY_EVEN:
        paritycfg = USART_PM_EVEN;
        break;
    }
    
    usart_deinit(USARTx);
    usart_baudrate_set(USARTx, baudval);
    usart_word_length_set(USARTx, wlen);
    usart_stop_bit_set(USARTx, stblen);
    usart_parity_config(USARTx, paritycfg);
    usart_receive_config(USARTx, USART_RECEIVE_ENABLE);
    usart_transmit_config(USARTx, USART_TRANSMIT_ENABLE);
    usart_enable(USARTx);

    return RT_EOK;
}

static rt_err_t gd32_control(struct rt_serial_device *serial, int cmd, void *arg)
{
    struct gd32_uart *uart;

    RT_ASSERT(serial != RT_NULL);
    uart = (struct gd32_uart *)serial->parent.user_data;
    uint32_t uart_periph = uart->uart_periph;

    switch (cmd) {
    case RT_DEVICE_CTRL_CLR_INT:
        /* disable rx irq */
        NVIC_DisableIRQ(uart->irqn);
        /* disable interrupt */
        usart_interrupt_disable(uart_periph, USART_INT_RBNE);
        break;
    case RT_DEVICE_CTRL_SET_INT:
        /* enable rx irq */
        NVIC_EnableIRQ(uart->irqn);
        usart_interrupt_enable(uart_periph, USART_INT_RBNE);
        break;
    }

    return RT_EOK;
}

static int gd32_putc(struct rt_serial_device *serial, char ch)
{
    struct gd32_uart *uart;

    RT_ASSERT(serial != RT_NULL);
    uart = (struct gd32_uart *)serial->parent.user_data;


    usart_data_transmit(uart->uart_periph, ch);
    while ((usart_flag_get(uart->uart_periph, USART_FLAG_TC) == RESET));

    return 1;
}

static int gd32_getc(struct rt_serial_device *serial)
{
    int ch;
    struct gd32_uart *uart;

    RT_ASSERT(serial != RT_NULL);
    uart = (struct gd32_uart *)serial->parent.user_data;

    ch = -1;
    if (usart_flag_get(uart->uart_periph, USART_FLAG_RBNE) != RESET)
        ch = usart_data_receive(uart->uart_periph);
    return ch;
}

/**
 * Uart common interrupt process. This need add to uart ISR.
 *
 * @param serial serial device
 */
static void uart_isr(struct rt_serial_device *serial)
{
    struct gd32_uart *uart = (struct gd32_uart *) serial->parent.user_data;

    RT_ASSERT(uart != RT_NULL);

    if ((usart_flag_get(uart->uart_periph, USART_INT_RBNE) != RESET) &&
            (usart_flag_get(uart->uart_periph, USART_FLAG_RBNE) != RESET)) {
        rt_hw_serial_isr(serial, RT_SERIAL_EVENT_RX_IND);
        /* Clear RXNE interrupt flag */
        usart_flag_clear(uart->uart_periph, USART_FLAG_RBNE);
    }
}

static const struct rt_uart_ops gd32_uart_ops = {
    gd32_configure,
    gd32_control,
    gd32_putc,
    gd32_getc,
};

int gd32_hw_usart_init(void)
{
    struct serial_configure config = RT_SERIAL_CONFIG_DEFAULT;
    int i;


    for (i = 0; i < sizeof(uarts) / sizeof(uarts[0]); i++) {
        uarts[i].serial->ops    = &gd32_uart_ops;
        uarts[i].serial->config = config;

        /* register UART device */
        rt_hw_serial_register(uarts[i].serial,
                              uarts[i].device_name,
                              RT_DEVICE_FLAG_RDWR | RT_DEVICE_FLAG_INT_RX,
                              (void *)&uarts[i]);
    }

    return 0;
}
INIT_BOARD_EXPORT(gd32_hw_usart_init);
#endif
