# encoding: utf-8
# data from: https://github.com/svenfuchs/i18n/blob/master/test/test_data/locales/plurals.rb

require 'redmine/i18n'

RDB_PLURALIZERS = {
  :af => lambda { |n| n == 1 ? :one : :other },
  :am => lambda { |n| [0, 1].include?(n) ? :one : :other },
  :ar => lambda { |n| n == 0 ? :zero : n == 1 ? :one : n == 2 ? :two : [3, 4, 5, 6, 7, 8, 9, 10].include?(n % 100) ? :few : [11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99].include?(n % 100) ? :many : :other },
  :az => lambda { |n| :other },
  :be => lambda { |n| n % 10 == 1 && n % 100 != 11 ? :one : [2, 3, 4].include?(n % 10) && ![12, 13, 14].include?(n % 100) ? :few : n % 10 == 0 || [5, 6, 7, 8, 9].include?(n % 10) || [11, 12, 13, 14].include?(n % 100) ? :many : :other },
  :bg => lambda { |n| n == 1 ? :one : :other },
  :bh => lambda { |n| [0, 1].include?(n) ? :one : :other },
  :bn => lambda { |n| n == 1 ? :one : :other },
  :bo => lambda { |n| :other },
  :bs => lambda { |n| n % 10 == 1 && n % 100 != 11 ? :one : [2, 3, 4].include?(n % 10) && ![12, 13, 14].include?(n % 100) ? :few : n % 10 == 0 || [5, 6, 7, 8, 9].include?(n % 10) || [11, 12, 13, 14].include?(n % 100) ? :many : :other },
  :ca => lambda { |n| n == 1 ? :one : :other },
  :cs => lambda { |n| n == 1 ? :one : [2, 3, 4].include?(n) ? :few : :other },
  :cy => lambda { |n| n == 1 ? :one : n == 2 ? :two : n == 8 || n == 11 ? :many : :other },
  :da => lambda { |n| n == 1 ? :one : :other },
  :de => lambda { |n| n == 1 ? :one : :other },
  :dz => lambda { |n| :other },
  :el => lambda { |n| n == 1 ? :one : :other },
  :en => lambda { |n| n == 1 ? :one : :other },
  :eo => lambda { |n| n == 1 ? :one : :other },
  :es => lambda { |n| n == 1 ? :one : :other },
  :et => lambda { |n| n == 1 ? :one : :other },
  :eu => lambda { |n| n == 1 ? :one : :other },
  :fa => lambda { |n| :other },
  :fi => lambda { |n| n == 1 ? :one : :other },
  :fil => lambda { |n| [0, 1].include?(n) ? :one : :other },
  :fo => lambda { |n| n == 1 ? :one : :other },
  :fr => lambda { |n| n.between?(0, 2) && n != 2 ? :one : :other },
  :fur => lambda { |n| n == 1 ? :one : :other },
  :fy => lambda { |n| n == 1 ? :one : :other },
  :ga => lambda { |n| n == 1 ? :one : n == 2 ? :two : :other },
  :gl => lambda { |n| n == 1 ? :one : :other },
  :gu => lambda { |n| n == 1 ? :one : :other },
  :guw => lambda { |n| [0, 1].include?(n) ? :one : :other },
  :ha => lambda { |n| n == 1 ? :one : :other },
  :he => lambda { |n| n == 1 ? :one : :other },
  :hi => lambda { |n| [0, 1].include?(n) ? :one : :other },
  :hr => lambda { |n| n % 10 == 1 && n % 100 != 11 ? :one : [2, 3, 4].include?(n % 10) && ![12, 13, 14].include?(n % 100) ? :few : n % 10 == 0 || [5, 6, 7, 8, 9].include?(n % 10) || [11, 12, 13, 14].include?(n % 100) ? :many : :other },
  :hu => lambda { |n| :other },
  :id => lambda { |n| :other },
  :is => lambda { |n| n == 1 ? :one : :other },
  :it => lambda { |n| n == 1 ? :one : :other },
  :iw => lambda { |n| n == 1 ? :one : :other },
  :ja => lambda { |n| :other },
  :jv => lambda { |n| :other },
  :ka => lambda { |n| :other },
  :km => lambda { |n| :other },
  :kn => lambda { |n| :other },
  :ko => lambda { |n| :other },
  :ku => lambda { |n| n == 1 ? :one : :other },
  :lb => lambda { |n| n == 1 ? :one : :other },
  :ln => lambda { |n| [0, 1].include?(n) ? :one : :other },
  :lt => lambda { |n| n % 10 == 1 && ![11, 12, 13, 14, 15, 16, 17, 18, 19].include?(n % 100) ? :one : [2, 3, 4, 5, 6, 7, 8, 9].include?(n % 10) && ![11, 12, 13, 14, 15, 16, 17, 18, 19].include?(n % 100) ? :few : :other },
  :lv => lambda { |n| n == 0 ? :zero : n % 10 == 1 && n % 100 != 11 ? :one : :other },
  :mg => lambda { |n| [0, 1].include?(n) ? :one : :other },
  :mk => lambda { |n| n % 10 == 1 ? :one : :other },
  :ml => lambda { |n| n == 1 ? :one : :other },
  :mn => lambda { |n| n == 1 ? :one : :other },
  :mo => lambda { |n| n == 1 ? :one : n == 0 ? :few : :other },
  :mr => lambda { |n| n == 1 ? :one : :other },
  :ms => lambda { |n| :other },
  :mt => lambda { |n| n == 1 ? :one : n == 0 || [2, 3, 4, 5, 6, 7, 8, 9, 10].include?(n % 100) ? :few : [11, 12, 13, 14, 15, 16, 17, 18, 19].include?(n % 100) ? :many : :other },
  :my => lambda { |n| :other },
  :nah => lambda { |n| n == 1 ? :one : :other },
  :nb => lambda { |n| n == 1 ? :one : :other },
  :ne => lambda { |n| n == 1 ? :one : :other },
  :nl => lambda { |n| n == 1 ? :one : :other },
  :nn => lambda { |n| n == 1 ? :one : :other },
  :no => lambda { |n| n == 1 ? :one : :other },
  :nso => lambda { |n| [0, 1].include?(n) ? :one : :other },
  :om => lambda { |n| n == 1 ? :one : :other },
  :or => lambda { |n| n == 1 ? :one : :other },
  :pa => lambda { |n| n == 1 ? :one : :other },
  :pap => lambda { |n| n == 1 ? :one : :other },
  :pl => lambda { |n| n == 1 ? :one : [2, 3, 4].include?(n % 10) && ![12, 13, 14].include?(n % 100) ? :few : :other },
  :ps => lambda { |n| n == 1 ? :one : :other },
  :pt => lambda { |n| [0, 1].include?(n) ? :one : :other },
  :"pt-PT" => lambda { |n| n == 1 ? :one : :other },
  :ro => lambda { |n| n == 1 ? :one : n == 0 ? :few : :other },
  :ru => lambda { |n| n % 10 == 1 && n % 100 != 11 ? :one : [2, 3, 4].include?(n % 10) && ![12, 13, 14].include?(n % 100) ? :few : n % 10 == 0 || [5, 6, 7, 8, 9].include?(n % 10) || [11, 12, 13, 14].include?(n % 100) ? :many : :other },
  :se => lambda { |n| n == 1 ? :one : n == 2 ? :two : :other },
  :sh => lambda { |n| n % 10 == 1 && n % 100 != 11 ? :one : [2, 3, 4].include?(n % 10) && ![12, 13, 14].include?(n % 100) ? :few : n % 10 == 0 || [5, 6, 7, 8, 9].include?(n % 10) || [11, 12, 13, 14].include?(n % 100) ? :many : :other },
  :sk => lambda { |n| n == 1 ? :one : [2, 3, 4].include?(n) ? :few : :other },
  :sl => lambda { |n| n % 100 == 1 ? :one : n % 100 == 2 ? :two : [3, 4].include?(n % 100) ? :few : :other },
  :sma => lambda { |n| n == 1 ? :one : n == 2 ? :two : :other },
  :smi => lambda { |n| n == 1 ? :one : n == 2 ? :two : :other },
  :smj => lambda { |n| n == 1 ? :one : n == 2 ? :two : :other },
  :smn => lambda { |n| n == 1 ? :one : n == 2 ? :two : :other },
  :sms => lambda { |n| n == 1 ? :one : n == 2 ? :two : :other },
  :so => lambda { |n| n == 1 ? :one : :other },
  :sq => lambda { |n| n == 1 ? :one : :other },
  :sr => lambda { |n| n % 10 == 1 && n % 100 != 11 ? :one : [2, 3, 4].include?(n % 10) && ![12, 13, 14].include?(n % 100) ? :few : n % 10 == 0 || [5, 6, 7, 8, 9].include?(n % 10) || [11, 12, 13, 14].include?(n % 100) ? :many : :other },
  :sv => lambda { |n| n == 1 ? :one : :other },
  :sw => lambda { |n| n == 1 ? :one : :other },
  :ta => lambda { |n| n == 1 ? :one : :other },
  :te => lambda { |n| n == 1 ? :one : :other },
  :th => lambda { |n| :other },
  :ti => lambda { |n| [0, 1].include?(n) ? :one : :other },
  :tk => lambda { |n| n == 1 ? :one : :other },
  :tl => lambda { |n| [0, 1].include?(n) ? :one : :other },
  :to => lambda { |n| :other },
  :tr => lambda { |n| :other },
  :uk => lambda { |n| n % 10 == 1 && n % 100 != 11 ? :one : [2, 3, 4].include?(n % 10) && ![12, 13, 14].include?(n % 100) ? :few : n % 10 == 0 || [5, 6, 7, 8, 9].include?(n % 10) || [11, 12, 13, 14].include?(n % 100) ? :many : :other },
  :ur => lambda { |n| n == 1 ? :one : :other },
  :vi => lambda { |n| :other },
  :wa => lambda { |n| [0, 1].include?(n) ? :one : :other },
  :yo => lambda { |n| :other },
  :zh => lambda { |n| :other },
  :zu => lambda { |n| n == 1 ? :one : :other }
}

module RdbI18nPatch
  def pluralize(locale, entry, count)
    return entry unless entry.is_a?(Hash) and count

    pluralizer = nil
    [locale, locale.to_s.split('-', 2).first].each do |lo|
      pluralizer = RDB_PLURALIZERS[lo.to_sym]
    end

    if pluralizer.respond_to?(:call)
      key = count == 0 && entry.has_key?(:zero) ? :zero : pluralizer.call(count)

      return entry[key] if entry.has_key?(key)
    end

    super
  end
end

Redmine::I18n::Backend.send :include, RdbI18nPatch
