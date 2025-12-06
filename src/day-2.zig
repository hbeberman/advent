const std = @import("std");
const common = @import("common.zig");

pub fn solve(allocator: std.mem.Allocator, path: [:0]const u8) !u32 {
    const contents = try common.load_input(allocator, path, "day-2-test.txt");
    defer allocator.free(contents);
    const result = try decode(contents);
    return result;
}

fn decode(ranges: []const u8) !u32 {
    std.debug.print("ranges: {s}", .{ranges});
    var iterator = std.mem.splitSequence(u8, ranges, "\n");
    var total: u32 = 0;

    while (iterator.next()) |range| {
        total += try validate_range(range) orelse continue;
    }
    return total;
}

fn validate_range(range: []const u8) !?u32 {
    std.debug.print("ranges: {s}", .{range});
    const start: u32 = 11;
    const end: u32 = 22;
    var total: u32 = 0;

    for (start..end + 1) |val| {
        const val_u32: u32 = @intCast(val);
        if (check_double(val_u32)) {
            total += val_u32;
        }
    }

    return total;
}

fn check_double(val: u32) bool {
    std.debug.print("val: {}\n", .{val});
    return false;
}
