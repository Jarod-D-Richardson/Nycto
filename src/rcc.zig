const chip = @import("chip.zig");
const Register = chip.Register;

pub const RCC = extern struct {
    CR: Register(u32),
    CFGR: Register(u32),
    CIR: Register(u32),
    APB2RSTR: Register(u32),
    APB1RSTR: Register(u32),
    AHBENR: Register(u32),
    APB2ENR: Register(packed struct(u32) {
        afioen: u1,
        reserved0: u1,
        iopaen: u1,
        iopben: u1,
        iopcen: u1,
        iopden: u1,
        iopeen: u1,
        reserved1: u2,
        adc1en: u1,
        adc2en: u1,
        time1en: u1,
        spi1en: u1,
        reserved2: u1,
        usart1en: u1,
        reserved3: u17,
    }),
    APB1ENR: Register(u32),
    BDCR: Register(u32),
    CSR: Register(u32),
    AHBSTR: Register(u32),
    CFGR2: Register(u32),
};

