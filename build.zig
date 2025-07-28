const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe_mod.addImport("Term", b.dependency("zterm", .{}).module("Term"));
    exe_mod.addImport("zargs", b.dependency("zargs", .{}).module("zargs"));

    const exe = b.addExecutable(.{
        .name = "zterm_cli",
        .root_module = exe_mod,
    });
    exe.linkLibC();
    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run CLI demo");
    run_step.dependOn(&run_cmd.step);
}
