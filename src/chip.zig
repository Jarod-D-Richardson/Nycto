

const std = @import("std");
const gpio = @import("gpio.zig");
const rcc = @import("rcc.zig");



pub fn Register(comptime T: type) type {
    const IntT = std.meta.Int(.unsigned, @bitSizeOf(T));
    return extern struct {
        raw: IntT,

        const Self = @This();
        const type_of = T;

        pub inline fn read(self: *volatile Self) T {
            return @bitCast(self.raw);
        }

        pub inline fn write_raw(self: *volatile Self, val: IntT) void {
            self.raw = val;
        }

        pub inline fn write(self: *volatile Self, val: T) void {
            comptime {
                std.debug.assert(@bitSizeOf(T) == @bitSizeOf(IntT));
            }
            self.write_raw(@bitCast(val));
        }

        pub inline fn modify(self: *volatile Self, fields: anytype) void {
            var val = self.read();
            inline for (@typeInfo(@TypeOf(fields)).Struct.fields) |field| {
                @field(val, field.name) = @field(fields, field.name);
            }
            self.write(val);
        }

    };
}

pub const Chip = struct {
    pub const peripherals = struct {
        pub const RCC: *volatile rcc.RCC = @ptrFromInt(0x4002_1000);
        pub const GPIOG: *volatile gpio.GPIO = @ptrFromInt(0x4001_2000);
        pub const GPIOF: *volatile gpio.GPIO = @ptrFromInt(0x4001_1C00);
        pub const GPIOE: *volatile gpio.GPIO = @ptrFromInt(0x4001_1800);
        pub const GPIOD: *volatile gpio.GPIO = @ptrFromInt(0x4001_1400);
        pub const GPIOC: *volatile gpio.GPIO = @ptrFromInt(0x4001_1000);
        pub const GPIOB: *volatile gpio.GPIO = @ptrFromInt(0x4001_0C00);
        pub const GPIOA: *volatile gpio.GPIO = @ptrFromInt(0x4001_0800);
        pub const AFIO: *volatile gpio.AFIO = @ptrFromInt(0x4001_0000);
    };
};








