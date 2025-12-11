const std = @import("std");

const advent = @import("advent");

const d1 = @import("day-1.zig");
const d2 = @import("day-2.zig");
const d3 = @import("day-3.zig");
const d4 = @import("day-4.zig");
const d5 = @import("day-5.zig");

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

    const d1_result = d1.solve(allocator, path) catch |err| {
        std.debug.print("Error: {}\n", .{err});
        std.posix.exit(1);
    };
    std.debug.print("Day 1 Result: {}\n", .{d1_result});

    const d2_result = d2.solve(allocator, path) catch |err| {
        std.debug.print("Error: {}\n", .{err});
        std.posix.exit(1);
    };
    std.debug.print("Day 2 Result: {}\n", .{d2_result});

    const d3_result = d3.solve(allocator, path) catch |err| {
        std.debug.print("Error: {}\n", .{err});
        std.posix.exit(1);
    };
    std.debug.print("Day 3 Result: {}\n", .{d3_result});

    const d4_result = d4.solve(allocator, path) catch |err| {
        std.debug.print("Error: {}\n", .{err});
        std.posix.exit(1);
    };
    std.debug.print("Day 4 Result: {}\n", .{d4_result});

    const d5_result = d5.solve(allocator, path) catch |err| {
        std.debug.print("Error: {}\n", .{err});
        std.posix.exit(1);
    };
    std.debug.print("Day 5 Result: {}\n", .{d5_result});
}

fn usage() void {
    std.debug.print("Usage: ./advent <path-to-data>\n", .{});
}
