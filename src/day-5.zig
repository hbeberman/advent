const std = @import("std");
const common = @import("common.zig");
const AdventError = common.AdventError;

const Mode = enum {
    RangeFind,
    SpoilCheck,
};

const Range = struct { min: u64, max: u64 };

pub fn solve(allocator: std.mem.Allocator, path: [:0]const u8) !u64 {
    const contents = try common.load_input(allocator, path, "day-5.txt");
    defer allocator.free(contents);
    const result = try decode(allocator, contents);
    return result;
}

fn decode(allocator: std.mem.Allocator, lines: []const u8) !u64 {
    const lines_trim = std.mem.trim(u8, lines, " \t\n\r");
    var iter = std.mem.splitSequence(u8, lines_trim, "\n");
    var total: u64 = 0;

    var mode: Mode = Mode.RangeFind;
    var ranges = std.ArrayList(Range){};
    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();

    while (iter.next()) |line| {
        if (line.len == 0) {
            mode = Mode.SpoilCheck;
            continue;
        }
        switch (mode) {
            Mode.RangeFind => {
                try range_build(arena.allocator(), line, &ranges);
            },
            Mode.SpoilCheck => {
                total += try fresh_check(line, &ranges);
            },
        }
    }
    return total;
}

fn fresh_check(line: []const u8, ranges: *std.ArrayList(Range)) !u64 {
    const id = std.fmt.parseInt(u64, line, 10) catch return AdventError.InvalidInput;

    //std.debug.print("id: {d}\n", .{id});
    for (ranges.items, 0..) |range, i| {
        _ = i;
        //std.debug.print("range {d}: {d}-{d}\n", .{ i, range.min, range.max });
        if (id >= range.min and id <= range.max) {
            return 1;
        }
    }

    return 0;
}

fn range_build(allocator: std.mem.Allocator, line: []const u8, ranges: *std.ArrayList(Range)) !void {
    var iter = std.mem.splitSequence(u8, line, "-");
    const minstr = iter.next() orelse return AdventError.InvalidInput;
    const maxstr = iter.next() orelse return AdventError.InvalidInput;
    const min = std.fmt.parseInt(u64, minstr, 10) catch return AdventError.InvalidInput;
    const max = std.fmt.parseInt(u64, maxstr, 10) catch return AdventError.InvalidInput;

    try ranges.append(allocator, Range{ .min = min, .max = max });
}
