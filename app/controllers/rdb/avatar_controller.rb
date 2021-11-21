# frozen_string_literal: true

class Rdb::AvatarController < ApplicationController
  GOLDEN_RATIO_CONJUGATE = 0.618033988749895

  def show
    respond_to do |format|
      format.svg { render inline: generate }
    end
  end

  private

  def generate
    <<~SVG
      <svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 50 50">
        <rect width="100%" height="100%" fill="#{fill_color}"/>
        <text fill="#fff" font-family="Helvetica,Arial,sans-serif" font-size="26" font-weight="500" x="50%" y="55%" dominant-baseline="middle" text-anchor="middle">
          #{letters}
        </text>
      </svg>
    SVG
  end

  def fill_color
    hue = (principal.id * GOLDEN_RATIO_CONJUGATE) % 1
    "hsl(#{hue * 255}, 50%, 30%)"
  end

  def letters
    str = principal.to_s
    if str =~ /[[:space:]]/
      parts = str.split(/[[:space:]]+/).reject(&:blank?)
    else
      parts = [str]
    end

    if parts.length > 1
      parts.first[0] + parts.last[0]
    else
      parts.first[0]
    end
  end

  def principal
    @principal ||= Principal.find(params[:id])
  end
end
