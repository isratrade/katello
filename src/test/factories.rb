FactoryGirl.define do

  factory :resource_type do
    name "resource"

    trait :all do
      name "all"
    end
  end

  factory :permission do
    resource

    trait :all do
      association :resource_type, :all
    end

    factory :all_permission, :traits => [:all]
  end

  #factory :role do
    #sequence(:name) { |n| "Role #{n}" }
    #description { Faker::Lorem.sentence(10) }
    #locked false

    #trait :admin do
      #name "ADMINISTRATOR"
      #description "Super administrator with all access."
      #locked true
    #end

    #factory :admin_role, :traits => [:admin]
  #end

  #factory :user do
    #username { Faker::Internet.user_name.gsub(/[^0-9a-z]+/i, '') }
    #email { Faker::Internet.email }
    #password "Secret1234"
    #disabled false

    #factory :user_with_admin, :aliases => [:admin] do
      #after_build do |user|
        #admin_role = Role.find_by_name("ADMINISTRATOR") || FactoryGirl.build(:admin_role)
        #user.roles = [admin_role]
      #end
    #end
  #end

  #factory :organization, :aliases => [:org] do
    #sequence(:name) { |n| "org#{n}" }
    #sequence(:label) { |n| "org#{n}" }
    #description { Faker::Lorem.sentence(10) }

    #trait :with_library do
      #library
    #end
  #end


  #factory :provider do
    #name { Faker::Internet.domain_word.titlecase }
    #description { Faker::Lorem.sentence(10) }
    #repository_url { Faker::Internet.url }
    #provider_type Provider::CUSTOM

    ## specify products_count to build products
    #ignore do
      #product_count 0
    #end

    #after_create do |provider, evaluator|
      #FactoryGirl.create_list(:product,
                              #evaluator.product_count,
                              #:provider => provider
                             #)
    #end

    #trait :redhat do
      #provider_type Provider::REDHAT
    #end
    #factory :redhat_provider, :traits => [:redhat]
  #end

  #factory :product do
    #sequence(:name) { |n| "photoshopv#{n}" }
    #sequence(:label) { |n| "photoshopv#{n}" }
    #description { Faker::Lorem.sentence(10) }
    ##association :environment, :factory => :env_with_library
    #environments { [FactoryGirl.build(:library)] }
  #end

  #factory :repository, :aliases => [:repo] do
    #sequence(:name) { |n| "repo#{n}" }
    #sequence(:pulp_id) {|n| "pulp-id-#{n}"}
    #sequence(:content_id) {|n| "content#{n}"}
    #enabled true
    #environment_product
  #end

  factory :changeset do
    name "changeset"
    state Changeset::NEW
  end

  factory :promotion_changeset do
    name "promotion changeset"
    state Changeset::NEW
  end

end