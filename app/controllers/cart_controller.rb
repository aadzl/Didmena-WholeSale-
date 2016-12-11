class CartController < ApplicationController

  def add_items_to_cart
    @items = params[:_json]
    @items.each do |item|
      initiate_cart
      @cart[item.keys.first] = item.values.first
    end
    redirect_to "/cart"
  end

  def initiate_cart
    if session[:cart] then
      @cart = session[:cart]
    else
      session[:cart] = {}
      @cart = session[:cart]
    end
  end

  def update_cart
    session[:cart] = {}
    params[:_json].each do |item|
      pid = item.keys[0];
      amount = item.values[0];
      session[:cart][pid] = amount;
    end
    # session[:cart] = params[:_json]  
    redirect_to :action => :show
  end

  def empty_cart
    session[:cart] = nil
    redirect_to :action => :show
  end

  # not really sure what is this meant to do
  # guessing it something that happens when user logs out
  def delete_session_cart
    id = params[:product_id]
    @cart.delete(id)
    redirect_to :back, notice: t('.notice')
  end

####################### - cart view methods - ##################

  # products and amounts ordered
  # models ordered
  # colors in model
  # products in models in storage

  def products_amounts_ordered
    @product_amount_list = {}
    @cart.each do |item|
      product = Product.find(item[0].to_i)
      amount = item[1].to_i
      @product_amount_list[product] = amount
    end
  end

  def models_in_order
    @models_ordered = {}
    @product_amount_list.each do |product, amount|
      model = Model.find(product.model_id)
      colors = Product.where(model_id: product.model_id).map {|product| product.color_id}
      @models_ordered[model] = colors.uniq!
    end
  end

  # def products_for_color model_id,color_id
  #   list_products = []
  #   all_sizes.each do |size_id|
  #     product = Product.where(model_id: model_id, color_id: color_id, size_id: size_id)
  #     list_products.push(product)
  #   end
  #   return list_products
  # end


  ############


  def convertCartToOrderItemList
    @order_item_list = []
    @cart.each do |item|
      product_id = item[0].to_i
      amount = item[1].to_i
      ordered_item = OrderedItem.new(product_id, amount)
      @order_item_list.push(ordered_item)
    end
    return @order_item_list
  end

  def filterModels
    @models_ordered = []
    @order_item_list.each do |item|
      @models_ordered.push(item.getModel)
    end
    return @models_ordered
  end

  def filterColorsForModels
    @mColors = {}
    @order_item_list.each do |item|
      model = item.getModel
      @mColors[model] = item.getUniqueColorsForModel
    end
    return @mColors
  end

  def filterProductsForModelsColor
    @products_for_models_color = []
    @mColors.each do |model, colors|
      colors.each do |color|
        all_sizes.each do |size|
          product = Product.where(model_id: model.id).where(color_id: color).where(size_id: size.id)
          @products_for_models_color.push(product)
        end
      end
    end
    return @products_for_models_color
  end


  def show
    initiate_cart
    convertCartToOrderItemList
    filterModels
    filterColorsForModels
    filterProductsForModelsColor

    products_amounts_ordered
    models_in_order
    # models [model, model, model]
    # colors in the model {model, [color_id, color_id, color_id]}
    # @colors_in_model = {}

    # @cart.each do |item|
    #   product_id = item[0].to_i
    #   amount = item[1].to_i
    #   ordered_item = OrderedItem.new(product_id, amount)
    #   @models_ordered.push(ordered_item.getModel)
    # end




    
    
    # binding.pry
    


    # @ordered_items = Array.new

    # @model_products = Hash.new

    # ordered_items_array = Array.new

    # if session[:cart] then
    #   @cart = session[:cart]
    # else
    #   @cart = {}
    # end

      # binding.pry

      @cart_total_cost = 0

      #per krepseli
      # @cart.each do |item|
        # binding.pry
        # oi = OrderedItem.new(item[0], item[0])
        # ordered_items_array.push(oi)
        # product = Product.find(item[0])

        # model = Model.find(product.model_id)
        # color = Domain.find(product.color_id)
        # size = Domain.find(product.size_id)

        # order_item = {"model" => model, "color" => color, "size" => size, "quantity" => item[1]}
        # @ordered_items.push(order_item)
        # price = model.price
        # quantity = item[1].to_i

        # product_cost = price * quantity
        # @cart_total_cost += product_cost
      # end
    # else
    #   @cart = []
    # end

    # if !@company.nil?
    #   if !@company.discount.nil? && !@cart_total_cost.nil? 
    #     @final_cost = @cart_total_cost - @company.discount
    #     @final_cost = @final_cost.to_i
    #   end
    # else 
    #   @final_cost = 0
    # end 

    # all_models = @ordered_items.collect { |x| x["model"].id }
    # @diff_models = all_models.uniq

    # @mcs_hash = Hash.new

    # @diff_models.each do |diff_model|

    #   model_items = @ordered_items.select { |x| x["model"].id == diff_model }

    #   all_model_colors = model_items.collect { |x| x["color"].id }
    #   diff_model_colors = all_model_colors.uniq

    #   answers = Array.new

    #   diff_model_colors.each do |model_color|
    #     model_color_items = model_items.select { |x| x["color"].id ==  model_color }
    #     answer_lines = Array.new

    #     answer_lines.push(model_color)
    #     total_quantity = 0
    #     @sizes.each do |s|
    #       q = "0"
    #       model_color_items.each do |item|
    #         if item["size"].id == s.id
    #           q = item["quantity"]
    #           total_quantity += q.to_i
    #           break
    #         end
    #       end
    #       answer_lines.push(q)
    #     end
    #     answer_lines.push(total_quantity)
    #     answers.push(answer_lines)
    #   end

    #   @mcs_hash[diff_model] = answers
    # end
  end
end
