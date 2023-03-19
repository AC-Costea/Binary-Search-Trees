class Node
    attr_accessor :data
    attr_accessor :left_child
    attr_accessor :right_child

    def initialize(data)
        @data = data
        @left_child = nil
        @right_child = nil
    end
end

class Tree
    def initialize(array)
        sorted_array = array.uniq.sort
        @root = build_tree(sorted_array)
    end

    def build_tree(array)
        return nil if array.nil? || array.empty?
        middle = (array.length + 1)/2
        root = Node.new(array[middle - 1])
        root.left_child = build_tree(array[0...middle - 1])
        root.right_child = build_tree(array[middle..array.length])
        return root
    end

    def insert(root = @root, data)
        return Node.new(data) if root.nil?
        if data == root.data
            return root
        elsif data < root.data
            root.left_child = insert(root.left_child, data)
        else
            root.right_child = insert(root.right_child, data)
        end
        return root
    end

    def min_value_node(node)
        current_node = node
        until current_node.left_child.nil?
            current_node = current_node.left_child
        end
        return current_node
    end

    def delete(root = @root, data)
        return root if root.nil?
        if data < root.data
            root.left_child = delete(root.left_child, data)
        elsif data > root.data
            root.right_child = delete(root.right_child, data)
        else
            if root.left_child.nil?
                next_node = root.right_child
                root = nil
                return next_node
            elsif root.right_child.nil?
                next_node = root.left_child
                root = nil
                return next_node
            end

            next_node = min_value_node(root.right_child)
            root.data = next_node.data
            root.right_child = delete(root.right_child, next_node.data)
        end
        return root
    end

    def find(root = @root, data)
        return nil if root.nil?
        if data == root.data
            return root
        elsif data < root.data
            root = find(root.left_child, data)
        else
            root = find(root.right_child, data)
        end
        return root
    end

    def level_order(root = @root, queue = [])
        return if root.nil?
        puts root.data
        queue << root.left_child unless root.left_child.nil?
        queue << root.right_child unless root.right_child.nil?
        level_order(queue.shift, queue)
    end

    def inorder(root = @root)
        return if root.nil?
        inorder(root.left_child)
        puts root.data
        inorder(root.right_child)
    end

    def preorder(root = @root)
        return if root.nil?
        puts root.data
        preorder(root.left_child)
        preorder(root.right_child)
    end

    def postorder(root = @root)
        return if root.nil?
        postorder(root.left_child)
        postorder(root.right_child)
        puts root.data
    end

    def height(root = @root)
        return 0 if root.nil?
        left_child_height = height(root.left_child)
        right_child_height = height(root.right_child)
        if left_child_height > right_child_height
            return left_child_height + 1
        else
            return right_child_height + 1
        end
    end

    def depth(root = @root, current_depth = 0, data)
        return nil if root.nil?
        
        if root.data == data
            return current_depth
        else
            left_depth = depth(root.left_child, current_depth + 1, data)
            return left_depth unless left_depth.nil?
            
            right_depth = depth(root.right_child, current_depth + 1, data)
            return right_depth unless right_depth.nil?
        end
    end

    def balanced?(root = @root)
        return true if root.nil?
        left_height = height(root.left_child)
        right_height = height(root.right_child)
        return true if (left_height - right_height).abs <= 1 && balanced?(root.left_child) && balanced?(root.right_child)
        false
    end

    def rebalance(root = @root, list = [])
        return list if root.nil?
        rebalance(root.left_child, list)
        list << root.data
        rebalance(root.right_child, list)
        @root = build_tree(list)
    end
end