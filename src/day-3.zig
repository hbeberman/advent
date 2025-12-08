const std = @import("std");
const common = @import("common.zig");
const AdventError = common.AdventError;

pub fn solve(allocator: std.mem.Allocator, path: [:0]const u8) !u64 {
    const contents = try common.load_input(allocator, path, "day-3.txt");
    defer allocator.free(contents);
    const result = try decode(contents);
    return result;
}

fn decode(banks: []const u8) !u64 {
    //std.debug.print("banks:\n{s}\n", .{banks});

    const banks_trim = std.mem.trim(u8, banks, " \t\n\r");
    var iter = std.mem.splitSequence(u8, banks_trim, "\n");
    var total: u64 = 0;

    while (iter.next()) |bank| {
        total += try joltage_bank(bank);
    }
    return total;
}

fn joltage_bank(bank: []const u8) !u8 {
    //std.debug.print("bank: {s}\n", .{bank});

    var first: u8 = 0;
    var second: u8 = 0;
    var prev_first: u8 = 0;

    for (0..bank.len) |char| {
        const val = bank[char];
        //std.debug.print("{d}-", .{val});
        if (val > first) {
            prev_first = first;
            first = val;
            second = 0;
            continue;
        }
        if (val > second) {
            second = val;
            if (second == '9') {
                break;
            }
        }
    }
    if (second == 0) {
        second = first;
        first = prev_first;
    }
    //std.debug.print("\nf:{c} s:{c}\n", .{ first, second });

    var buf: [2]u8 = undefined;
    const num = try std.fmt.bufPrint(&buf, "{c}{c}", .{ first, second });
    const joltage = try std.fmt.parseInt(u8, num, 10);

    return joltage;
}
