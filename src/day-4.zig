const std = @import("std");
const common = @import("common.zig");
const AdventError = common.AdventError;

pub fn solve(allocator: std.mem.Allocator, path: [:0]const u8) !u64 {
    const contents = try common.load_input(allocator, path, "day-4-test.txt");
    defer allocator.free(contents);
    const result = try decode(contents);
    return result;
}

fn decode(map_input: []u8) !u64 {
    var write_index: usize = 0;

    var width: usize = undefined;
    if (std.mem.indexOf(u8, map_input, "\n")) |index| {
        width = index;
    }

    for (map_input) |char| {
        if (char != '\n') {
            map_input[write_index] = char;
            write_index += 1;
        }
    }
    var map = map_input[0..write_index];
    map[2] = 'x';
    const height = map.len / width;
    var total: u64 = 0;
    total += 0;

    std.debug.print("{s}\n", .{map});
    std.debug.print("width: {d} height: {d}\n", .{
        width,
        height,
    });

    return total;
}
