public class BTerm.Config {
	//terminal
	public static int scrollback_lines = 1000;
	public static bool mouse_autohide = true;
	public static int terminal_size_heigth = 24;
	public static int terminal_size_width = 80;

	//mainwindow
	public static int default_heigth = 400;
	public static int default_width = 640;
}

public class BTerm.Exec {
	//exec_id
	public static const int move_up = 0;
	public static const int move_down = 1;
	public static const int move_left = 2;
	public static const int move_right = 3;
	public static const int remove = 4;
	public static const int add = 5;
}
