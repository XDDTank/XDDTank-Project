package militaryrank.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import militaryrank.MilitaryRankManager;
   import road7th.data.DictionaryData;
   import tofflist.TofflistModel;
   
   public class FootView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Scale9CornerImage;
      
      private var _tenbitm:Bitmap;
      
      private var _todaybitm:Bitmap;
      
      private var _changcibitm:Bitmap;
      
      private var _junxianbitm:Bitmap;
      
      private var _zhanji1bitm:Bitmap;
      
      private var _zhanji2bitm:Bitmap;
      
      private var _militaryNameTxt:FilterFrameText;
      
      private var _militaryTotalScoreTxt:FilterFrameText;
      
      private var _militaryCountTxt:FilterFrameText;
      
      private var _militaryScoreTxt:FilterFrameText;
      
      public function FootView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.militaryrank.footBg");
         this._tenbitm = ComponentFactory.Instance.creatBitmap("asset.militaryrank.tenRankbitm");
         this._todaybitm = ComponentFactory.Instance.creatBitmap("asset.militaryrank.todayRankbitm");
         this._changcibitm = ComponentFactory.Instance.creatBitmap("asset.militaryrank.changci");
         this._junxianbitm = ComponentFactory.Instance.creatBitmap("asset.militaryrank.junxian");
         this._zhanji1bitm = ComponentFactory.Instance.creatBitmap("asset.militaryrank.zhanjibitm");
         this._zhanji2bitm = ComponentFactory.Instance.creatBitmap("asset.militaryrank.zhanji");
         PositionUtils.setPos(this._zhanji2bitm,"militaryrank.zahnji2Pos");
         addChild(this._bg);
         addChild(this._tenbitm);
         addChild(this._todaybitm);
         addChild(this._changcibitm);
         addChild(this._junxianbitm);
         addChild(this._zhanji1bitm);
         addChild(this._zhanji2bitm);
         this._militaryNameTxt = ComponentFactory.Instance.creatComponentByStylename("militaryrank.footInfo.Txt");
         this._militaryTotalScoreTxt = ComponentFactory.Instance.creatComponentByStylename("militaryrank.footInfo.Txt");
         this._militaryCountTxt = ComponentFactory.Instance.creatComponentByStylename("militaryrank.footInfo.Txt");
         this._militaryScoreTxt = ComponentFactory.Instance.creatComponentByStylename("militaryrank.footInfo.Txt");
         PositionUtils.setPos(this._militaryNameTxt,"militaryrank.NameTxt.pos");
         PositionUtils.setPos(this._militaryTotalScoreTxt,"militaryrank.TotalScore.pos");
         PositionUtils.setPos(this._militaryCountTxt,"militaryrank.Count.pos");
         PositionUtils.setPos(this._militaryScoreTxt,"militaryrank.Score.pos");
         addChild(this._militaryNameTxt);
         addChild(this._militaryTotalScoreTxt);
         addChild(this._militaryCountTxt);
         addChild(this._militaryScoreTxt);
         var _loc1_:SelfInfo = PlayerManager.Instance.Self;
         var _loc2_:DictionaryData = TofflistModel.Instance.getMilitaryLocalTopN(3);
         if(_loc1_.MilitaryRankTotalScores < ServerConfigManager.instance.getMilitaryData()[12] || !_loc2_.hasKey(_loc1_.ID))
         {
            this._militaryNameTxt.text = MilitaryRankManager.Instance.getMilitaryRankInfo(_loc1_.MilitaryRankTotalScores).Name;
         }
         else
         {
            this._militaryNameTxt.text = MilitaryRankManager.Instance.getOtherMilitaryName(_loc2_[_loc1_.ID][0])[0];
         }
         this._militaryTotalScoreTxt.text = PlayerManager.Instance.Self.MilitaryRankTotalScores.toString();
         this._militaryCountTxt.text = PlayerManager.Instance.Self.FightCount.toString();
         this._militaryScoreTxt.text = PlayerManager.Instance.Self.MilitaryRankScores.toString();
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.addEventListener(PlayerManager.UPDATE_PLAYER_PROPERTY,this.__onUpdate);
      }
      
      private function __onUpdate(param1:Event) : void
      {
         var _loc2_:SelfInfo = PlayerManager.Instance.Self;
         var _loc3_:DictionaryData = TofflistModel.Instance.getMilitaryLocalTopN(3);
         if(_loc2_.MilitaryRankTotalScores < ServerConfigManager.instance.getMilitaryData()[12] || !_loc3_.hasKey(_loc2_.ID))
         {
            this._militaryNameTxt.text = MilitaryRankManager.Instance.getMilitaryRankInfo(_loc2_.MilitaryRankTotalScores).Name;
         }
         else
         {
            this._militaryNameTxt.text = MilitaryRankManager.Instance.getOtherMilitaryName(_loc3_[_loc2_.ID][0])[0];
         }
         this._militaryTotalScoreTxt.text = PlayerManager.Instance.Self.MilitaryRankTotalScores.toString();
         this._militaryCountTxt.text = PlayerManager.Instance.Self.FightCount.toString();
         this._militaryScoreTxt.text = PlayerManager.Instance.Self.MilitaryRankScores.toString();
      }
      
      public function dispose() : void
      {
         PlayerManager.Instance.removeEventListener(PlayerManager.UPDATE_PLAYER_PROPERTY,this.__onUpdate);
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._tenbitm);
         this._tenbitm = null;
         ObjectUtils.disposeObject(this._todaybitm);
         this._todaybitm = null;
         ObjectUtils.disposeObject(this._changcibitm);
         this._changcibitm = null;
         ObjectUtils.disposeObject(this._junxianbitm);
         this._junxianbitm = null;
         ObjectUtils.disposeObject(this._zhanji1bitm);
         this._zhanji1bitm = null;
         ObjectUtils.disposeObject(this._zhanji2bitm);
         this._zhanji2bitm = null;
         ObjectUtils.disposeObject(this._militaryNameTxt);
         this._militaryNameTxt = null;
         ObjectUtils.disposeObject(this._militaryTotalScoreTxt);
         this._militaryTotalScoreTxt = null;
         ObjectUtils.disposeObject(this._militaryCountTxt);
         this._militaryCountTxt = null;
         ObjectUtils.disposeObject(this._militaryScoreTxt);
         this._militaryScoreTxt = null;
      }
   }
}
