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
    //std.debug.print("checking range {s}\n", .{range});
    var iter = std.mem.splitSequence(u8, range, "-");
    const start: u64 = try std.fmt.parseInt(u64, (iter.next() orelse return AdventError.InvalidInput), 10);
    const end: u64 = try std.fmt.parseInt(u64, (iter.next() orelse return AdventError.InvalidInput), 10);
    if (iter.next() != null) return AdventError.InvalidInput;

    var total: u64 = 0;
    for (start..end + 1) |val| {
        const val_u64: u64 = @intCast(val);
        if (try check_value(val_u64)) {
            total += val_u64;
        }
    }

    return total;
}

fn check_value(val: u64) !bool {
    //std.debug.print("val:{}\n", .{val});
    const T = @TypeOf(val);
    const MAXLEN = std.fmt.comptimePrint("{d}", .{std.math.maxInt(T)}).len;
    var buf: [MAXLEN + 1]u8 = undefined;
    const num = try std.fmt.bufPrintZ(&buf, "{}", .{val});
    const half = num.len / 2;
    for (1..half + 1) |chunk_size| {
        if (check_chunks(num, chunk_size)) {
            //std.debug.print("val:{} chunk:{} valid\n", .{ val, chunk_size });
            return true;
        }
    }
    return false;
}

fn check_chunks(num: [:0]u8, chunk_size: usize) bool {
    if (num.len % chunk_size != 0) {
        return false;
    }

    var iter = std.mem.window(u8, num, chunk_size, chunk_size);
    const match = iter.next() orelse unreachable;
    //std.debug.print("chunk_size:{} match:{s}\n", .{ chunk_size, match });
    while (iter.next()) |chunk| {
        if (!std.mem.eql(u8, match, chunk)) {
            return false;
        }
    }
    return true;
}
