package worldboss.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import worldboss.player.RankingPersonInfo;
   
   public class RankViewItem extends Sprite implements Disposeable
   {
       
      
      private var _txtName:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _ranking:FilterFrameText;
      
      private var _num:int;
      
      private var _personInfo:RankingPersonInfo;
      
      private var _topThreeRink:ScaleFrameImage;
      
      private var _ranknamePos:Point;
      
      private var _nameTip:HeroTouchItem;
      
      public function RankViewItem(param1:int, param2:RankingPersonInfo)
      {
         super();
         this._num = param1;
         this._personInfo = param2;
         this._init();
      }
      
      private function _init() : void
      {
         this._txtName = ComponentFactory.Instance.creat("toffilist.listItemNameText1");
         addChild(this._txtName);
         if(this._num <= 3)
         {
            this._topThreeRink = ComponentFactory.Instance.creat("worldboss.topThreeRink");
            addChild(this._topThreeRink);
            this._topThreeRink.setFrame(this._num);
         }
         else
         {
            this._ranking = ComponentFactory.Instance.creat("worldBoss.ranking.rank");
            addChild(this._ranking);
         }
         if(this._personInfo == null)
         {
            return;
         }
         this._intEvent();
         this._ranknamePos = ComponentFactory.Instance.creatCustomObject("worldboss.awardview.ranknamePos");
         DisplayUtils.setDisplayPos(this._txtName,this._ranknamePos);
         this._txtName.text = this._personInfo.nickName;
         if(this._personInfo.isVip)
         {
            this._txtName.visible = false;
            this._vipName = ComponentFactory.Instance.creatComponentByStylename("vipBossName");
            this._vipName.x = this._txtName.x;
            this._vipName.y = this._txtName.y;
            this._vipName.text = this._txtName.text;
            addChild(this._vipName);
         }
         this.setValue();
      }
      
      private function _intEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this._onItemClick);
      }
      
      private function _removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this._onItemClick);
      }
      
      public function _onItemClick(param1:MouseEvent) : void
      {
         var _loc3_:Point = null;
         if(this._nameTip == null)
         {
            this._nameTip = ComponentFactory.Instance.creatCustomObject("worldBoss.nameText");
         }
         this._nameTip.playerName = this._personInfo.nickName;
         this._nameTip.id = this._personInfo.userId;
         var _loc2_:String = this._txtName.text;
         _loc3_ = this.localToGlobal(new Point(mouseX,mouseY));
         this._nameTip.x = _loc3_.x;
         this._nameTip.y = _loc3_.y;
         this._nameTip.setVisible = true;
      }
      
      private function setValue() : void
      {
         this._txtName.text = this._personInfo.nickName;
         if(this._ranking)
         {
            this._ranking.text = this._num.toString() + "th";
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            this.parent.removeChild(this);
         }
         this._removeEvent();
         this._txtName = null;
         this._ranking = null;
         this._vipName = null;
      }
   }
}
