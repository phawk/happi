# frozen_string_literal: true
class FeatureBlockComponent < ViewComponent::Base
  attr_reader :title, :align

  renders_one :image
  renders_one :text

  def initialize(title: nil, align: :left)
    @title = title
    @align = align
  end

  def align_right?
    align.to_sym == :right
  end
end
