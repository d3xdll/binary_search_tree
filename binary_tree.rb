class Node
  attr_accessor :value, :left, :right

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :given_array, :root

  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array)
    return nil if array.empty?
    array = array.uniq.sort
    mid = array.length / 2
    root = Node.new(array[mid])
    root.left = build_tree(array[0...mid])
    root.right = build_tree(array[mid + 1..-1])
    root
  end

  def insert(value, root = @root)
    if !root.left && !root.right
      node = Node.new(value)
      root.value > value ? root.left = node : root.right = node
      node
    elsif value < root.value
      insert(value, root.left)
    elsif value > root.value
      insert(value, root.right)
    end
  end

  def delete(value, root = @root)
    return root if root.nil?

    if value < root.value
      root.left = delete(value, root.left)
    elsif value > root.value
      root.right = delete(value, root.right)
    else
      if root.right.nil?
        temp = root.left
        root = nil
        return temp
      elsif root.left.nil?
        temp = root.right
        root = nil
        return temp
      end

      temp = two_values_min(root.right)
      root.value = temp.value
      root.right = delete(temp.value, root.right)
    end
    root 
  end

  def two_values_min(root)
    current = root
    until current.left.nil?
      current = current.left
    end
    current
  end

  def find(value, root = @root)
    return root if root.value == value

    value < root.value ? find(value, root.left) : find(value, root.right)
  end

  def level_order(node = @root)
    queue = []
    arr = []
    queue.push(node)
    until queue.empty?
      current = queue.shift
      arr = arr.push(block_given? ? yield(current.value) : current.value)
      queue.push(current.left) if current.left
      queue.push(current.right) if current.right
    end
    arr
  end

  def return_inorder(node = @root, arr = [], &block)
    return if node.nil?

    return_inorder(node.left, arr, &block)
    arr.push(block_given? ? block.call(node.value) : node.value)
    return_inorder(node.right, arr, &block)
    arr
  end

  def return_preorder(node = @root, arr = [], &block)
    return if node.nil?

    return_inorder(node.left, arr, &block)
    arr.push(block_given? ? block.call(node.value) : node.value)
    return_inorder(node.right, arr, &block)
    arr
  end

  def preorder(node = @root, arr = [], &block)
    return if node.nil?

    arr.push(block_given? ? block.call(node.value) : node.value)
    preorder(node.left, arr, &block)
    preorder(node.right, arr, &block)
  end

  def postorder(node = @root, arr = [], &block)
    return if node.nil?

    postorder(node.left, arr, &block)
    postorder(node.right, arr, &block)
    arr.push(block_given? ? block.call(node.value) : node.value)
  end
  
  def node_height(node = @root, count = -1)
    return count if node.nil?

    count += 1
    left_height = node_height(node.left, count)
    right_height = node_height(node.right, count)
    [left_height, right_height].max

  end

  def depth(value, node = @root, count = 0)
    return -1 if node.nil?

    return 0 if node.value == value

    if node.value > value
      count = depth(value, node.left, count)
      count += 1 if count >= 0
    else
      count = depth(value, node.right, count)
      count += 1 if count >= 0
    end
    count
  end

  def balanced?(node = @root, left = 0, right = 0)
    p left = node_height(node.left) if node.left
    p right = node_height(node.right) if node.right
    (left - right).abs < 2
  end 

  def balance
    Tree.new(return_inorder)
    self.pretty_print
  end 

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

end


input = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345]

new_tree = Tree.new(input)

new_tree.pretty_print

# p new_tree.find(4)
# new_tree.pretty_print

# new_tree.level_order {|value| p "Level is #{i} and value is  #{value}"}
# p new_tree.return_inorder{|val| p "here #{val}"}
# p new_tree.preorder{|val| p "here #{val}"}
new_tree.postorder
# p new_tree.node_height(new_tree.find(67))

p new_tree.balanced?

new_tree.balance