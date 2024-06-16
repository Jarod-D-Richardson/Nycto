const std = @import("std");

const chip = @import("chip.zig");

const gpio = @import("gpio.zig");


export fn _start() void {
    @call(.auto, main, .{});
}

pub export fn main() void {
    const peris = chip.Chip.peripherals;

    // enable gpioc
    peris.RCC.APB2ENR.modify(.{ .iopcen = 1 });

    var gpioc = peris.GPIOC;
    gpioc.CRH.modify(.{
        .mode13 = .Output2,
        .mode14 = .Input,
        .cnf14 = .PullUpDown_AFPushPull,
    });

    const cnt: comptime_int = 10_000;

    //var is_high = false;
    while (true) {

        if (gpioc.IDR.read().idr14 == 1) {
            while (gpioc.IDR.read().idr14 != 0) {
            }
            if (gpioc.ODR.read().odr13 == 1) {
                gpioc.BSRR.modify(.{.br13 = 1});
                var i: u32 = 0;
                while (i < cnt) {
                    i += 1;
                }
            } else {
                gpioc.BSRR.modify(.{.bs13 = 1});
                var i: u32 = 0;
                while (i < cnt) {
                    i += 1;
                }
            }
        }
    }
}
