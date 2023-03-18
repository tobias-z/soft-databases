use std::ptr::addr_of_mut;

use page_rank::{generate_ranks, Node};

pub mod page_rank;

fn main() {
    let mut one = Node::new(1);
    let mut two = Node::new(2);
    let mut three = Node::new(3);
    let mut four = Node::new(4);
    let mut five = Node::new(5);

    let mut node1 = Node::new(7);
    let mut node2 = Node::new(8);
    let mut node3 = Node::new(9);
    let mut node4 = Node::new(10);
    let mut node5 = Node::new(11);
    let mut node6 = Node::new(12);

    one.add_edge(addr_of_mut!(two));
    two.add_edge(addr_of_mut!(one));
    three.add_edge(addr_of_mut!(one));
    four.add_edge(addr_of_mut!(one));
    five.add_edge(addr_of_mut!(one));

    node1.add_edge(addr_of_mut!(node2));
    node2.add_edge(addr_of_mut!(node1));
    node3.add_edge(addr_of_mut!(node1));
    node4.add_edge(addr_of_mut!(node1));
    node5.add_edge(addr_of_mut!(node4));
    node6.add_edge(addr_of_mut!(node5));

    let mut nodes = vec![
        std::ptr::addr_of_mut!(one),
        std::ptr::addr_of_mut!(two),
        std::ptr::addr_of_mut!(three),
        std::ptr::addr_of_mut!(four),
        std::ptr::addr_of_mut!(five),
        std::ptr::addr_of_mut!(node1),
        std::ptr::addr_of_mut!(node2),
        std::ptr::addr_of_mut!(node3),
        std::ptr::addr_of_mut!(node4),
        std::ptr::addr_of_mut!(node5),
        std::ptr::addr_of_mut!(node6),
    ];

    generate_ranks(&mut nodes);

    for node in nodes {
        unsafe {
            let node = node.as_ref().unwrap();
            println!("node: {}, rank: {}", node.val, node.rank);
        }
    }
}
