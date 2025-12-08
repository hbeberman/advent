const std = @import("std");
const common = @import("common.zig");
const AdventError = common.AdventError;

pub fn solve(allocator: std.mem.Allocator, path: [:0]const u8) !u64 {
    const contents = try common.load_input(allocator, path, "day-2.txt");
    defer allocator.free(contents);
    const result = try decode(contents);
    return result;
}

fn decode(ranges: []const u8) !u64 {
    //std.debug.print("ranges: {s}\n", .{ranges});
    const ranges_trim = std.mem.trim(u8, ranges, " \t\n\r");

    var iterator = std.mem.splitSequence(u8, ranges_trim, ",");
    var total: u64 = 0;

    while (iterator.next()) |range| {
        if (range.len == 0) {
            continue;
        }
        total += try validate_range(range) orelse continue;
    }
    return total;
}

fn validate_range(range: []const u8) !?u64 {
    //std.debug.print("range: {s} len={d}\n", .{ range, range.len });

    var iter = std.mem.splitSequence(u8, range, "-");
    const start: u64 = try std.fmt.parseInt(u64, (iter.next() orelse return AdventError.InvalidInput), 10);
    const end: u64 = try std.fmt.parseInt(u64, (iter.next() orelse return AdventError.InvalidInput), 10);
    if (iter.next() != null) return AdventError.InvalidInput;

    var total: u64 = 0;
    for (start..end + 1) |val| {
        const val_u64: u64 = @intCast(val);
        if (try check_double(val_u64)) {
            total += val_u64;
        }
    }

    return total;
}

fn check_double(val: u64) !bool {
    //std.debug.print("val:{}\n", .{val});
    const T = @TypeOf(val);
    const MAXLEN = std.fmt.comptimePrint("{d}", .{std.math.maxInt(T)}).len;
    var buf: [MAXLEN + 1]u8 = undefined;
    const num = try std.fmt.bufPrintZ(&buf, "{}", .{val});
    if (num.len % 2 == 0x1) return false;
    const half = num.len / 2;

    const first = num[0..half];
    const second = num[half..num.len];
    const equal = std.mem.eql(u8, first, second);
    if (equal) {
        //std.debug.print("num:{s} len:{d} f:{s} s:{s} equal:{}\n", .{ num, num.len, first, second, equal });
    }
    return equal;
}
