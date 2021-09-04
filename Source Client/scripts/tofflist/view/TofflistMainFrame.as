package tofflist.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import tofflist.TofflistController;
   import tofflist.TofflistEvent;
   import tofflist.TofflistModel;
   import tofflist.data.TofflistPlayerInfo;
   
   public class TofflistMainFrame extends Frame
   {
       
      
      private var _contro:TofflistController;
      
      private var _leftView:TofflistLeftView;
      
      private var _rightView:TofflistRightView;
      
      private var _arrayList:TofflistPlayerInfo;
      
      private var _list1:Array;
      
      private var _list2:Array;
      
      private var _titleBmp:Bitmap;
      
      public function TofflistMainFrame(param1:TofflistController)
      {
         this._contro = param1;
         super();
         this.initView();
         this.addEvent();
      }
      
      public function get rightView() : TofflistRightView
      {
         return this._rightView;
      }
      
      private function initView() : void
      {
         escEnable = true;
         this._titleBmp = ComponentFactory.Instance.creatBitmap("asset.Tofflist.title");
         addToContent(this._titleBmp);
         this._leftView = new TofflistLeftView();
         addToContent(this._leftView);
         this._rightView = new TofflistRightView(this._contro);
         PositionUtils.setPos(this._rightView,"tofflist.rightViewPos");
         addToContent(this._rightView);
      }
      
      public function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         TofflistModel.addEventListener(TofflistEvent.TOFFLIST_DATA_CHANGER,this.__tofflistDataChange);
         TofflistModel.addEventListener(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.__crossServerTofflistDataChange);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         this._contro = null;
         this.removeEvent();
         if(this._titleBmp)
         {
            ObjectUtils.disposeObject(this._titleBmp);
         }
         this._titleBmp = null;
         if(this._leftView)
         {
            ObjectUtils.disposeObject(this._leftView);
         }
         this._leftView = null;
         if(this._rightView)
         {
            ObjectUtils.disposeObject(this._rightView);
         }
         this._rightView = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         TofflistModel.removeEventListener(TofflistEvent.TOFFLIST_DATA_CHANGER,this.__tofflistDataChange);
         TofflistModel.removeEventListener(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.__crossServerTofflistDataChange);
      }
      
      private function __crossServerTofflistDataChange(param1:TofflistEvent) : void
      {
         this._rightView.updateTime(param1.data.data.lastUpdateTime);
         switch(String(param1.data.flag))
         {
            case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_DAY:
               this._rightView.orderList(TofflistModel.Instance.crossServerIndividualGradeDay.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_WEEK:
               this._rightView.orderList(TofflistModel.Instance.crossServerIndividualGradeWeek.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.crossServerIndividualGradeAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_DAY:
               this._rightView.orderList(TofflistModel.Instance.crossServerIndividualExploitDay.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_WEEK:
               this._rightView.orderList(TofflistModel.Instance.crossServerIndividualExploitWeek.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.crossServerIndividualExploitAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_DAY:
               this._rightView.orderList(TofflistModel.Instance.crossServerPersonalCharmvalueDay.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_WEEK:
               this._rightView.orderList(TofflistModel.Instance.crossServerPersonalCharmvalueWeek.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.crossServerPersonalCharmvalue.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_GRADE_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaGradeAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_DAY:
               this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaAssetDay.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_WEEK:
               this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaAssetWeek.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaAssetAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_DAY:
               this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaExploitDay.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_WEEK:
               this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaExploitWeek.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaExploitAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_BATTLE_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaBattleAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_PERSONAL_BATTLE_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.crossServerPersonalBattleAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_DAY:
               this._rightView.orderList(TofflistModel.Instance.crossServerPersonalAchievementPointDay.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_WEEK:
               this._rightView.orderList(TofflistModel.Instance.crossServerPersonalAchievementPointWeek.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.crossServerPersonalAchievementPoint.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_DAY:
               this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaCharmvalueDay.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_WEEK:
               this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaCharmvalueWeek.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaCharmvalue.list);
         }
      }
      
      private function __tofflistDataChange(param1:TofflistEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         this._rightView.updateTime(param1.data.data.lastUpdateTime);
         switch(String(param1.data.flag))
         {
            case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_DAY:
               this._rightView.orderList(TofflistModel.Instance.individualGradeDay.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_WEEK:
               this._rightView.orderList(TofflistModel.Instance.individualGradeWeek.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_ACCUMULATE:
               _loc2_ = TofflistModel.Instance.individualGradeAccumulate.list;
               if(_loc2_.length != 0)
               {
                  this._arrayList = _loc2_[0];
                  this._list1 = [];
                  this._list2 = [];
                  _loc3_ = 1;
                  while(_loc3_ < _loc2_.length)
                  {
                     if(this._arrayList.GP == _loc2_[_loc3_].GP)
                     {
                        this._list2.push(_loc2_[_loc3_]);
                     }
                     else
                     {
                        this.listArray(_loc2_[_loc3_]);
                     }
                     _loc3_++;
                  }
                  this.listArray(_loc2_[_loc3_]);
               }
               this._rightView.orderList(this._list1);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_DAY:
               this._rightView.orderList(TofflistModel.Instance.individualExploitDay.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_WEEK:
               this._rightView.orderList(TofflistModel.Instance.individualExploitWeek.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.individualExploitAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_DAY:
               this._rightView.orderList(TofflistModel.Instance.PersonalCharmvalueDay.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_WEEK:
               this._rightView.orderList(TofflistModel.Instance.PersonalCharmvalueWeek.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.PersonalCharmvalue.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_MATCHES_WEEK:
               this._rightView.orderList(TofflistModel.Instance.personalMatchesWeek.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_GRADE_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.consortiaGradeAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_DAY:
               this._rightView.orderList(TofflistModel.Instance.consortiaAssetDay.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_WEEK:
               this._rightView.orderList(TofflistModel.Instance.consortiaAssetWeek.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.consortiaAssetAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_DAY:
               this._rightView.orderList(TofflistModel.Instance.consortiaExploitDay.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_WEEK:
               this._rightView.orderList(TofflistModel.Instance.consortiaExploitWeek.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.consortiaExploitAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_BATTLE_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.consortiaBattleAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_PERSONAL_BATTLE_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.personalBattleAccumulate.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_DAY:
               this._rightView.orderList(TofflistModel.Instance.PersonalAchievementPointDay.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_WEEK:
               this._rightView.orderList(TofflistModel.Instance.PersonalAchievementPointWeek.list);
               break;
            case TofflistEvent.TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.PersonalAchievementPoint.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_DAY:
               this._rightView.orderList(TofflistModel.Instance.ConsortiaCharmvalueDay.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_WEEK:
               this._rightView.orderList(TofflistModel.Instance.ConsortiaCharmvalueWeek.list);
               break;
            case TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_ACCUMULATE:
               this._rightView.orderList(TofflistModel.Instance.ConsortiaCharmvalue.list);
               break;
            case TofflistEvent.TOFFLIST_PERSON_LOCAL_MILITARY:
               this._rightView.orderList(TofflistModel.Instance.Person_local_military.list);
               break;
            case TofflistEvent.TOFFLIST_ARENA_LOCAL_SCORE_DAY:
               this._rightView.orderList(TofflistModel.Instance.arenaLocalScoreDay.list);
               break;
            case TofflistEvent.TOFFLIST_ARENA_LOCAL_SCORE_WEEK:
               this._rightView.orderList(TofflistModel.Instance.arenaLocalScoreWeek.list);
               break;
            case TofflistEvent.TOFFLIST_ARENA_CROSS_SCORE_DAY:
               this._rightView.orderList(TofflistModel.Instance.arenaCrossScoreDay.list);
               break;
            case TofflistEvent.TOFFLIST_ARENA_CROSS_SCORE_WEEK:
               this._rightView.orderList(TofflistModel.Instance.arenaCrossScoreWeek.list);
         }
      }
      
      public function clearDisplayContent() : void
      {
         this._rightView.orderList(new Array());
         this._rightView.updateTime(null);
      }
      
      private function listArray(param1:TofflistPlayerInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TofflistPlayerInfo = null;
         var _loc6_:int = 0;
         if(this._list2.length == 0)
         {
            this._list1.push(this._arrayList);
            this._arrayList = param1;
         }
         else
         {
            this._list2.push(this._arrayList);
            this._arrayList = param1;
            _loc2_ = this._list1.length;
            _loc3_ = 0;
            while(_loc3_ < this._list2.length)
            {
               _loc4_ = this._list2.length - 1;
               _loc5_ = this._list2[_loc3_];
               _loc6_ = 0;
               while(_loc6_ < this._list2.length)
               {
                  if(_loc5_.Repute < this._list2[_loc6_].Repute)
                  {
                     _loc4_--;
                  }
                  _loc6_++;
               }
               this._list1[_loc2_ + _loc4_] = _loc5_;
               _loc3_++;
            }
            this._list2.length = 0;
         }
      }
   }
}
