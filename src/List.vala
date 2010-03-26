using GLib;

public class BTerm.Item {
	private BTerm.BTermial term;
	public uint id;
	private BTerm.Item next;
	private BTerm.Item prev;
	private BTerm.List parent;

	public Item(uint id_in, BTerm.List par) {
		this.term = new BTerm.BTermial(this);
		this.parent = par;
		this.id = id_in;
		this.next = null;
		this.prev = null;
	}

	public void set_next(BTerm.Item? nn) { this.next = nn; }
	public BTerm.Item? get_next() { return this.next; }
	public void set_prev(BTerm.Item? nn) { this.prev = nn; }
	public BTerm.Item? get_prev() { return this.prev; }
	public void set_parent(BTerm.List np) { this.parent = np; }

	private void move_up() { this.parent.move_up(this.id); }
	private void move_down() { this.parent.move_down(this.id); }
}

public class BTerm.List {
	private BTerm.Item root;
	private BTerm.Item tail;

	private BTerm.List next;
	private BTerm.List prev;

	static uint count;
	uint local_count;

	public uint id;
	private BTerm.LList parent;

	public List(uint id_in, BTerm.LList par) {
		this.parent = par;
		this.id = id_in;
		var tmp = new BTerm.Item(List.count++, this);
		this.local_count = 1;
		tmp.set_next(null);
		tmp.set_prev(null);
		this.root = tmp;
		this.tail = tmp;
	}
	
	public List.with_Item(uint id_in, BTerm.LList par, BTerm.Item tcrtwth) {
		this.parent = par;
		this.id = id_in;
		this.local_count = 1;
		tcrtwth.set_next(null);
		tcrtwth.set_prev(null);
		tcrtwth.set_parent(this);
		this.root = tcrtwth;
		this.tail = tcrtwth;
		
	}
	
	public void create_item() {
		int r = GLib.Random.int_range(0,2);
		for(int i = 0; i < r; i++) {
			var tmp = new BTerm.Item(List.count++, this);
			this.append(tmp);
			//this.tail.set_next(tmp);
			//tmp.set_prev(this.tail);
			//this.tail = tmp;
		}
	}

	public bool has(uint id) {
		var tmp = this.root;
		while(tmp != null) {
			if(tmp.id == id) return true;
			tmp = tmp.get_next();
		}
		return false;
	}
	
	public BTerm.Item remove(uint id) {
		BTerm.Item tmp = this.root;
		while(tmp.id != id) {
			tmp = tmp.get_next();
		}
		var n = tmp.get_next();
		var p = tmp.get_prev();
		if(n == null && p == null) { //delete
			this.parent.remove_list(this.id);
		} else if(n == null && p != null) { //set tail
			p.set_next(null);
			this.tail = p;
		} else if(n != null && p == null) { //set root
			n.set_prev(null);
			this.root = n;
		} else { //normal
			n.set_prev(p);
			p.set_next(n);
		}
		tmp.set_prev(null);
		tmp.set_next(null);
		this.local_count--;
		return tmp;	
	}

	public void append(BTerm.Item ti) {
		this.tail.set_next(ti);
		ti.set_prev(this.tail);
		ti.set_next(null);
		ti.set_parent(this);
		this.tail = ti;
		this.local_count++;
	}

	private BTerm.Item? find(uint id) {
		var tmp = this.root;
		while(tmp != null) {
			if(tmp.id == id) return tmp;
			tmp = tmp.get_next();
		}
		return null;	
	}
	
	public void move_down(uint id) {
		var tmp = this.find(id);
		if(tmp == null) return;
		if(tmp.get_next() == null) return;

		var ln = tmp.get_next().get_next();
		var lp = tmp.get_prev();
		var tmp2 = tmp.get_next();

		if(lp != null) {
			lp.set_next(tmp2);
			tmp2.set_prev(lp);
		} else {
			tmp2.set_prev(null);
			this.root = tmp2;
		}

		tmp2.set_next(tmp);
		tmp.set_prev(tmp2);

		if(ln != null) {
			tmp.set_next(ln);
			ln.set_prev(tmp);
		} else {
			tmp.set_next(null);
			this.tail = tmp;
		}
	}
	
	public void move_up(uint id) {
		var tmp = this.find(id);
		if(tmp == null) return; //check if exists in list
		if(tmp.get_prev() == null) return; //check if allready root

		var ln = tmp.get_next();
		var lp = tmp.get_prev().get_prev();
		var tmp2 = tmp.get_prev();

		if(lp != null) {	//normal swap
			lp.set_next(tmp);
			tmp.set_prev(lp);
		} else {			//new root
			tmp.set_prev(null);
			this.root = tmp;
		}

		tmp.set_next(tmp2);
		tmp2.set_prev(tmp);

		if(ln != null) {
			tmp2.set_next(ln);
			ln.set_prev(tmp2);
		} else {
			tmp2.set_next(null);
			this.tail = tmp2;
		}
	}

	public void print() {
		var tmp = this.root;
		stdout.printf("list id %u with %u objs= ",this.id, this.get_local_count());
		while(tmp != null) {
			stdout.printf("%u ", tmp.id);
			tmp = tmp.get_next();
		}
		stdout.printf("\t\troot %u; tail %u \n", this.root.id, this.tail.id);
	}

	public void set_next(BTerm.List? nn) { this.next = nn; }
	public BTerm.List get_next() { return this.next; }
	public void set_prev(BTerm.List? nn) { this.prev = nn; }
	public BTerm.List get_prev() { return this.prev; }
	public static uint get_count() { return List.count; }
	public uint get_local_count() { return this.local_count; }
}

public class BTerm.LList {
	private BTerm.List root;
	private BTerm.List tail;

	uint count;

	public LList() {
		var tmp = new BTerm.List(this.count++, this);
		tmp.create_item();
		tmp.set_next(null);
		tmp.set_prev(null);
		root = tmp;
		tail = tmp;
	}
	
	public void create_item() {
		var tmp = new BTerm.List(this.count++, this);
		tmp.create_item();
		this.tail.set_next(tmp);
		tmp.set_prev(this.tail);
		this.tail = tmp;
	}

	public void create_item_with_next(BTerm.Item tcrtwth) {
		var tmp = new BTerm.List.with_Item(this.count++, this, tcrtwth);
		this.tail.set_next(tmp);
		tmp.set_prev(this.tail);
		tmp.set_next(null);
		this.tail = tmp;
	}

	public void create_item_with_prev(BTerm.Item tcrtwth) {
		var tmp = new BTerm.List.with_Item(this.count++, this, tcrtwth);
		tmp.set_next(this.root);
		tmp.set_prev(null);
		this.root.set_prev(tmp);
		this.root = tmp;
	}

	public void print() {
		var tmp = this.root;
		stdout.printf("root is %u\n", tmp.id);
		while(tmp != null) {
			tmp.print();
			tmp = tmp.get_next();
		}
		stdout.printf("tail is %u\n", this.tail.id);
	}

	private BTerm.List? find_in_list(uint id) {
		var tmp = this.root;
		while(tmp != null) {
			if(tmp.has(id)) return tmp;
			tmp = tmp.get_next();
		}
		return null;
	}

	private BTerm.List? find_list(uint id) {
		var tmp = this.root;
		while(tmp != null) {
			if(tmp.id == id) return tmp;
			tmp = tmp.get_next();
		}
		return null;
	}

	public void remove(uint id) {
		var tmp = this.find_in_list(id);
		if(tmp == null) return;
		tmp.remove(id);
	}

	public void remove_list(uint id) {
		var tmp = this.find_list(id);
		if(tmp == null) return;
		var p = tmp.get_prev();
		var n = tmp.get_next();
		if(p == null && n == null) {
			stdout.printf("\n\n\nprogram has ended\n\n\n");
			//end program
		} else if(p == null && n != null) {
			n.set_prev(null);
			this.root = n;
		} else if(p != null && n == null) {
			p.set_next(null);
			this.tail = p;
		} else {
			p.set_next(n);
			n.set_prev(p);
		}
		tmp.set_prev(null);
		tmp.set_next(null);	
	}

	public void move_left(uint id) {
		var tmp = this.find_in_list(id);
		var l = tmp.get_next();
		var tobj = tmp.remove(id);
	 	if(l != null) l.append(tobj);
		else this.create_item_with_next(tobj);
	}
	
	public void move_right(uint id) {
		var tmp = this.find_in_list(id);
		var p = tmp.get_prev();
		var tobj = tmp.remove(id);
	 	if(p != null) p.append(tobj);
		else this.create_item_with_prev(tobj);
	}
	
	public void move_up(uint id) {
		var tmp = this.find_in_list(id);
		tmp.move_up(id);
	}
	
	public void move_down(uint id) {
		var tmp = this.find_in_list(id);
		tmp.move_down(id);
	}

	public void has(uint id) {
		var tmp = this.root;
		while(tmp != null) {
			if(tmp.has(id)) {
				stdout.printf("%u found in List %u\n",id, tmp.id);
			}
			tmp = tmp.get_next();
		}
	}
}

public static int main(string[] args) {
	var t = new BTerm.LList();
	for(int i = 0; i <3; i++) {
		t.create_item();
	}
	int mu = Random.int_range(0,(int)BTerm.List.get_count());
	t.print();
	stdout.printf("\n");
	for(int i = 0; i < 15; i++) {
		mu = Random.int_range(0,(int)BTerm.List.get_count());
		int s = Random.int_range(1,5);
		stdout.printf("\n");
		switch(s) {
			case 1:
				stdout.printf("move up %d\n", mu);
				t.move_up(mu);
				break;
			case 2:
				stdout.printf("move down %d\n", mu);
				t.move_down(mu);
				break;
			case 3:
				stdout.printf("move left %d\n", mu);
				t.move_left(mu);
				break;
			case 4:
				stdout.printf("move right %d\n", mu);
				t.move_right(mu);
				break;
			default:
				stdout.printf("invalid case %d\n", s);
				break;
		}
		stdout.printf("\n");
		t.print();
	}
	stdout.printf("\n");
/*	for(int i = 0; i < 25; i++) {
		mu = Random.int_range(0,(int)BTerm.List.get_count());
		stdout.printf("remove %d ", mu);
		t.remove(mu);
	}*/
	t.print();
	return 0;
}
