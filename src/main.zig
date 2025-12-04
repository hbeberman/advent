const std = @import("std");
const advent = @import("advent");
const d1 = @import("day-1.zig");

pub fn main() !void {
    std.debug.print("Advent 2025 in Zig!\n", .{} );

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) std.debug.panic("Leak occured", .{});
    }
    var argiter = try std.process.ArgIterator.initWithAllocator(allocator);
    defer argiter.deinit();

    // Discard the program name, at least one arg exists
    _ = argiter.next();

    const path = argiter.next() orelse {
        std.debug.print("Error: No test file path provided\n", .{});
        return error.MissingPath;
    };

    try d1.solve(allocator, path);
}
