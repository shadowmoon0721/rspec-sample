require 'rails_helper'

RSpec.describe FoodEnquete, type: :model do
  describe '正常系の機能' do
    context '回答する' do
      it '正しく登録できること 料理:やきそば food_id: 2, 
                            満足度:良い score: 3, 
                            希望するプレゼント:ビール飲み放題 present_id: 1)' do

        enquete = FactoryBot.build(:food_enquete_tanaka)

        # [Point.3-3-2]「バリデーションが正常に通ること(バリデーションエラーが無いこと)」を検証します。
        expect(enquete).to be_valid

        # [Point.3-3-3]テストデータを保存します。
        enquete.save

        # [Point.3-3-4][Point.3-3-3]で保存したデータを取得します。
        answered_enquete = FoodEnquete.find(1);

        # [Point.3-3-5][Point.3-3-1]で作成したデータを同一か検証します。
        expect(answered_enquete.name).to eq('田中 太郎')
        expect(answered_enquete.mail).to eq('taro.tanaka@example.com')
        expect(answered_enquete.age).to eq(25)
        expect(answered_enquete.food_id).to eq(2)
        expect(answered_enquete.score).to eq(3)
        expect(answered_enquete.request).to eq('おいしかったです。')
        expect(answered_enquete.present_id).to eq(1)

      end
    end
  end

  describe 'アンケート回答時の条件' do
    context 'メールアドレスを確認すること' do

      before do
        FactoryBot.create(:food_enquete_tanaka)
      end

      it '同じメールアドレスで再び回答できないこと' do

        re_enquete_tanaka = FactoryBot.build(:food_enquete_tanaka, food_id: 0, score: 1, present_id: 0, request: "スープがぬるかった")


        # [Point.3-6-3]メールアドレスが既に存在するメッセージが含まれることを検証します。
        expect(re_enquete_tanaka).not_to be_valid
        expect(re_enquete_tanaka.errors[:mail]).to include(I18n.t('errors.messages.taken')) 
        expect(re_enquete_tanaka.save).to be_falsey
        expect(FoodEnquete.all.size).to eq 1
      end

      it '異なるメールアドレスで回答できること' do

        enquete_yamada = FactoryBot.build(:food_enquete_yamada)
  
        expect(enquete_yamada).to be_valid
        enquete_yamada.save
        # [Point.3-6-4]問題なく登録できます。
        expect(FoodEnquete.all.size).to eq 2
      end
    end
    
    context '年齢を確認すること' do
      it '未成年はビール飲み放題を選択できないこと' do

        enquete_sato = FactoryBot.build(:food_enquete_sato)

        expect(enquete_sato).not_to be_valid
        # [Point.3-5-4]成人のみ選択できる旨のメッセージが含まれることを検証します。
        expect(enquete_sato.errors[:present_id]).to include(I18n.t('activerecord.errors.models.food_enquete.attributes.present_id.cannot_present_to_minor'))
      end

      it '成人はビール飲み放題を選択できること' do

        enquete_sato = FactoryBot.build(:food_enquete_sato, age: 20)

        # [Point.3-5-6]「バリデーションが正常に通ること(バリデーションエラーが無いこと)」を検証します。
        expect(enquete_sato).to be_valid
      end
    end
  end

  describe '#adult?' do
    it '20歳未満は成人ではないこと' do
      foodEnquete = FoodEnquete.new
      # [Point.3-5-1]未成年になることを検証します。
      expect(foodEnquete.send(:adult?, 19)).to be_falsey
    end 

    it '20歳以上は成人であること' do
      foodEnquete = FoodEnquete.new
      # [Point.3-5-2]成人になることを検証します。
      expect(foodEnquete.send(:adult?, 20)).to be_truthy
    end 
  end

  describe '共通バリデーション' do
    it_behaves_like '入力項目の有無'
    it_behaves_like 'メールアドレスの形式'
  end

  describe '共通メソッド' do
    it_behaves_like '価格の表示'
    it_behaves_like '満足度の表示'
  end

end

