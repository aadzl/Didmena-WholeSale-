module ModelsHelper

  def find_model_product(color, size)
    @model_product = Product.where(size_id: size).where(color_id: color).where(model_id: @model.id)
  end

  def can_order?
    return product_exist && product_in_storage
  end

  def collection_type
    "for #{@type} | collection #{@collection}" 
  end

  def model_price
    "price #{sprintf '%.2f', @model.price}"
  end

  def product_exist
    return @model_product.exists?
  end

  def thumbnail(model)
    if model.model_attachments.present?
      model.model_attachments.first.avatar_url
    else 
      "http://www.petakids.com/wp-content/uploads/2015/11/Cute-Red-Bunny.jpg" 
    end
  end



  def product_in_storage
    return @model_product.take.in_storage
  end

  def products_available(model)
  # def model_has_product_in_storage(model)
    in_storage = model.products.map { |product| product.in_storage }
    return in_storage.include?(true)
  end

  def products_in_storage
    return (@products.map { |p| p.in_storage }).include?(true)
  end

  def value(color)
    Domain.find(color).meaning
  end

  def getUniquePurchaseProducts
    products = Purchase.all.map { |purchase| purchase.product_id }
    return products.uniq
  end

  def canDelete(model_id, color_id)
    products = Product.where(model_id: model_id, color_id: color_id);
    products.each do |product|
      if getUniquePurchaseProducts.include?(product.id)
        return false
      end
    end
  end
end



