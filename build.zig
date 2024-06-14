const std = @import("std");

pub fn build(b: *std.Build) void {

    const optimize = b.standardOptimizeOption(.{});

    const elf = b.addExecutable(.{
        .name = "app.elf",
        .root_source_file = b.path("src/main.zig"),
        .target = b.resolveTargetQuery(.{
                .cpu_arch = .thumb,
                .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m3},
                .os_tag = .freestanding,
                .abi = .eabi,
        }),
        .optimize = optimize,
    });

    elf.setLinkerScript(b.path("memory.ld"));
    b.installArtifact(elf);

    const gen_bin = b.addObjCopy(elf.getEmittedBin(), .{.format = .bin});
    gen_bin.step.dependOn(&elf.step);
    const copy_bin = b.addInstallBinFile(gen_bin.getOutput(), "app.bin");

    const bin_step = b.step("bin", "Generate binary file to be flashed");
    bin_step.dependOn(&copy_bin.step);

    //const program_str = "\"program " ++ b.getInstallPath(copy_bin.dir, copy_bin.dest_rel_path) ++ " exit 0x08000000\"";
    //const program_str = "\"program zig-out/bin/app.bin exit 0x08000000\"";

    //const flash_cmd = b.addSystemCommand(&[_][]const u8{
        //"openocd -f /home/jarod/Jarod/Embedded/Projects/Nycto/openocd.cfg",
        // "openocd",
        // "-f",
        // "interface/stlink.cfg",
        // "-f",
        // "target/stm32f1x.cfg",
        // "-c",
        // program_str,
    //});


    const flash_cmd = b.addSystemCommand(&.{"bash"});

    //flash_cmd.addArgs(&.{"bash"});

    flash_cmd.addFileArg(b.path("flash.sh"));
    flash_cmd.addFileArg(b.path("openocd.cfg"));
    flash_cmd.addFileArg(b.path("zig-out/bin/app.bin"));

    // flash_cmd.addArgs(&.{
    //     "-f"
    // });
    // flash_cmd.addFileArg(b.path("openocd.cfg"));
    //
    // flash_cmd.addArgs(&.{
    //     "-c",
    //     "program",
    // });
    //
    // flash_cmd.addFileArg(b.path("zig-out/bin/app.bin"));
    //
    // flash_cmd.addArgs(&.{
    //     "exit","0x08000000",
    // });
    //

    flash_cmd.step.dependOn(&copy_bin.step);

    const flash_step = b.step("flash", "Flash binary to board");
    flash_step.dependOn(&flash_cmd.step);


}
