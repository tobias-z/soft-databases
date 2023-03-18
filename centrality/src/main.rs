use std::ptr::addr_of_mut;

use page_rank::{generate_ranks, Node};

pub mod page_rank;

fn main() {
    let mut node1 = Node::new(1);
    let mut node2 = Node::new(2);
    let mut node3 = Node::new(3);
    let mut node4 = Node::new(4);
    let mut node5 = Node::new(5);

    let mut node7 = Node::new(7);
    let mut node8 = Node::new(8);
    let mut node9 = Node::new(9);
    let mut node10 = Node::new(10);
    let mut node11 = Node::new(11);
    let mut node12 = Node::new(12);

    node1.add_edge(addr_of_mut!(node2));
    node2.add_edge(addr_of_mut!(node1));
    node3.add_edge(addr_of_mut!(node1));
    node4.add_edge(addr_of_mut!(node1));
    node5.add_edge(addr_of_mut!(node1));

    node7.add_edge(addr_of_mut!(node8));
    node8.add_edge(addr_of_mut!(node7));
    node9.add_edge(addr_of_mut!(node7));
    node10.add_edge(addr_of_mut!(node7));
    node11.add_edge(addr_of_mut!(node10));
    node12.add_edge(addr_of_mut!(node11));

    let graph = vec![
        addr_of_mut!(node1),
        addr_of_mut!(node2),
        addr_of_mut!(node3),
        addr_of_mut!(node4),
        addr_of_mut!(node5),
        addr_of_mut!(node7),
        addr_of_mut!(node8),
        addr_of_mut!(node9),
        addr_of_mut!(node10),
        addr_of_mut!(node11),
        addr_of_mut!(node12),
    ];

    generate_ranks(&graph);

    for node in graph {
        unsafe {
            let node = node.as_ref().unwrap();
            println!("node: {}, rank: {}", node.val, node.rank);
        }
    }
}
