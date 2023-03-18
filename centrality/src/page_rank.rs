use rand::Rng;

#[derive(Debug)]
pub struct Node {
    pub val: usize,
    edges: Vec<*mut Node>,
    pub rank: i32,
}

impl Node {
    pub fn new(val: usize) -> Self {
        Self {
            val,
            edges: vec![],
            rank: 0,
        }
    }

    pub fn add_edge(&mut self, node: *mut Node) {
        self.edges.push(node);
    }

    fn increment_rank(&mut self) {
        self.rank += 1;
    }
}

pub fn generate_ranks(all_nodes: &Vec<*mut Node>) {
    let mut visits = 0;
    let mut rng = rand::thread_rng();
    let mut should_find_next = true;
    let mut node = all_nodes.get(0).unwrap();
    while visits < 50000000 {
        if should_find_next {
            let next_index = rng.gen::<usize>() % all_nodes.len();
            node = all_nodes.get(next_index).unwrap();
        }
        should_find_next = visit_nodes(&mut visits, node);
    }
}

fn visit_nodes(visits: &mut i32, node: &*mut Node) -> bool {
    if visits > &mut 50000000 {
        return false;
    }
    let num = rand::thread_rng().gen_range(0..100);
    let damping_factor = 94;
    if num > damping_factor {
        return true;
    }
    unsafe {
        let node = node.as_mut().unwrap();
        node.increment_rank();
        *visits += 1;
        if node.edges.is_empty() {
            return true;
        }
        for edge in node.edges.as_mut_slice() {
            if visit_nodes(visits, edge) {
                return true;
            }
        }
        false
    }
}
