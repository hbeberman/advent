const std = @import("std");

const advent = @import("advent");

const d1 = @import("day-1.zig");

pub fn main() !void {
    std.debug.print("Advent 2025 in Zig!\n", .{});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) std.debug.panic("Leak occured", .{});
    }
    var argiter = try std.process.ArgIterator.initWithAllocator(allocator);
    defer argiter.deinit();

    if (std.os.argv.len != 2) {
        usage();
        std.posix.exit(1);
    }

    // Discard the program name, at least one arg exists
    _ = argiter.next();

    const path = argiter.next() orelse unreachable;

    const d1_result = try d1.solve(allocator, path);
    std.debug.print("Day 1 Result: {}\n", .{d1_result});
}

fn usage() void {
    std.debug.print("Usage: ./advent <path-to-data>\n", .{});
}
