const std = @import("std");

const chip = @import("chip.zig");

export fn _start() void {
    @call(.auto, main, .{});
}


pub export fn main() void {
    const peris = chip.Chip.peripherals;

    // enable gpioc
    peris.RCC.APB2ENR.modify(.{.iopcen = 1});

    var gpioc = peris.GPIOC;
    gpioc.CRH.modify(.{.mode13 = .Output2});

    var is_high = false;
    while (true) {
        var i: u32 = 0;

        if (is_high) {
            //gpioc.ODR.modify(.{.odr13 = 0});
            gpioc.BSRR.modify(.{.br13 = 1});
            is_high = false;
        } else {
            //gpioc.ODR.modify(.{.odr13 = 1});
            gpioc.BSRR.modify(.{.bs13 = 1});
            is_high = true;
        }
        while (i < 300_000) { // Wait a bit
            i += 1;
        }
    }
}
