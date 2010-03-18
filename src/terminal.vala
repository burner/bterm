/* bterm a wmii like terminal emulator
 * forked from vala-terminal
 *
 * (C) 2007-2010 Michael 'Mickey' Lauer <mickey@vanille-media.de>
 * (C) 2009 Aapo Rantalainen
 * (C) 2010	Robert "BuRnEr" Schadek
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 */

using GLib;
using Gdk;
using Gtk;
using Vte;

public class BTerm.BTerminal : HBox {
	private Terminal terminal;
	public signal void selection(bool active);
	private static const string mod0_key = "Alt_L";
	private bool mod0;

	construct {
		terminal = new Vte.Terminal();
		// auto-exit may become a preference at some point?
		terminal.child_exited += term => { destroy(); };
		terminal.eof += term => { destroy(); };
		terminal.window_title_changed += term => { Gtk.Window toplevel = (Gtk.Window) get_toplevel(); toplevel.set_title( term.window_title ); };
		pack_start( terminal, true, true, 0 );

		terminal.set_scrollback_lines( 1000 );
		terminal.set_mouse_autohide( true );
		terminal.set_backspace_binding( TerminalEraseBinding.ASCII_DELETE);
		// work around bug in VTE. FIXME: Clear with upstream
		terminal.set_size(80, 24);
		stdout.printf("col count = %ld\n", terminal.row_count);
		terminal.fork_command( (string) 0, (string[]) 0, new string[]{}, Environment.get_variable( "HOME" ), true, true, true );
		terminal.key_press_event.connect(key_press_event_cb);		
		terminal.key_release_event.connect(key_release_event_cb);		
	}

	public void paste() {
		terminal.paste_primary();
	}

	public void paste_command( string command )	{
	   terminal.feed_child( command + "\0", -1 );
	}

	public void set_size(uint count) {
		long y = (long)Math.floor(this.terminal.get_row_count()/(long)count);
		stdout.printf("y = %ld\n", y);
		this.terminal.set_size(this.terminal.get_column_count(), y);
		this.show_all();
	}

	bool key_press_event_cb(Gdk.EventKey button) {
		switch(Gdk.keyval_name(button.keyval)) {
			case mod0_key:
				this.mod0 = true;
				BTerm.MainWindow.add_term(0);
				break;
		}
		return false;
	}
	
	bool key_release_event_cb(Gdk.EventKey button) {
		switch(Gdk.keyval_name(button.keyval)) {
			case mod0_key:
				this.mod0 = false;
				BTerm.MainWindow.add_term(0);
				break;
		}
		return false;
	}

}
