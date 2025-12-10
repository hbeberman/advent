const std = @import("std");
const common = @import("common.zig");
const AdventError = common.AdventError;

pub fn solve(allocator: std.mem.Allocator, path: [:0]const u8) !u64 {
    const contents = try common.load_input(allocator, path, "day-4.txt");
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
    const map = map_input[0..write_index];
    const height = map.len / width;

    var total: u64 = 0;
    var result: u64 = 1;
    while (result > 0) {
        result = checkMap(map, width, height);
        total += result;
        //std.debug.print("result: {}\n\n", .{result});
    }
    return total;
}

fn checkMap(map: []u8, width: usize, height: usize) u64 {
    var total: u64 = 0;
    for (0..height) |row| {
        for (0..width) |col| {
            const pos = row * width + col;
            if (map[pos] == '.') {
                //std.debug.print("{c}", .{map[pos]});
                continue;
            }
            if (map[pos] == 'x') {
                //std.debug.print("{c}", .{map[pos]});
                map[pos] = '.';
                continue;
            }

            const irow: isize = @intCast(row);
            const icol: isize = @intCast(col);

            const neighbors = checkNeighbors(map, width, height, irow, icol);

            if (neighbors < 4) {
                total += 1;
                map[pos] = 'x';
                //std.debug.print("x", .{});
            } else {
                //std.debug.print("{c}", .{map[row * width + col]});
            }
        }
        //std.debug.print("\n", .{});
    }
    return total;
}

fn checkNeighbors(map: []u8, width: usize, height: usize, argrow: isize, argcol: isize) u8 {
    var neighbors: u8 = 0;

    var row = argrow - 1;
    var col = argcol - 1;

    const end_col = argcol + 2;
    const end_row = argrow + 2;

    //std.debug.print("\nrow:{} col:{} ", .{ argrow, argcol });

    while (row < end_row) : (row += 1) {
        while (col < end_col) : (col += 1) {
            //std.debug.print("{}:{}", .{ row, col });
            const found = checkCell(map, width, height, row, col);

            neighbors += found;
        }
        col = argcol - 1;
    }
    //std.debug.print(" neighbors:{}\n", .{neighbors});

    return neighbors - 1;
}

fn checkCell(map: []u8, width: usize, height: usize, row: isize, col: isize) u8 {
    if (row < 0 or row >= height or col < 0 or col >= width) {
        return 0;
    }
    const urow: usize = @intCast(row);
    const ucol: usize = @intCast(col);
    const val = map[urow * width + ucol];
    if (val == '@') {
        return 1;
    }
    return 0;
}
