package militaryrank.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import militaryrank.MilitaryRankManager;
   import road7th.data.DictionaryData;
   import tofflist.TofflistModel;
   
   public class MilitaryIcon extends Sprite implements ITipedDisplay, Disposeable
   {
       
      
      private var _iconPic:ScaleFrameImage;
      
      private var _score:int;
      
      private var _tipDirctions:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String;
      
      private var _tipData:String;
      
      private var _size:int;
      
      private var _info:PlayerInfo;
      
      public function MilitaryIcon(param1:PlayerInfo)
      {
         super();
         this.init();
         this.initView();
         this._info = param1;
         this.initEvent();
      }
      
      private function init() : void
      {
         this._tipStyle = "ddt.view.tips.OneLineTip";
         this._tipGapV = 10;
         this._tipGapH = 10;
         this._tipDirctions = "7,4,6,5";
         ShowTipManager.Instance.addTip(this);
      }
      
      private function initEvent() : void
      {
         if(this._info.ID == PlayerManager.Instance.Self.ID)
         {
            this.buttonMode = true;
            this.addEventListener(MouseEvent.CLICK,this.__showMilitaryFrame);
         }
      }
      
      private function __showMilitaryFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(StateManager.isInFight)
         {
            return;
         }
         MilitaryRankManager.Instance.show();
      }
      
      public function set Info(param1:PlayerInfo) : void
      {
         this._info = param1;
      }
      
      public function setMilitary(param1:int) : void
      {
         var _loc2_:DictionaryData = null;
         this._score = param1;
         if(this._iconPic)
         {
            _loc2_ = TofflistModel.Instance.getMilitaryLocalTopN();
            if(param1 < ServerConfigManager.instance.getMilitaryData()[12] || !_loc2_.hasKey(this._info.ID))
            {
               this._iconPic.setFrame(MilitaryRankManager.Instance.getMilitaryFrameNum(param1));
            }
            else if(this._score != ServerConfigManager.instance.getMilitaryData()[12])
            {
               this._iconPic.setFrame(MilitaryRankManager.Instance.getOtherMilitaryName(_loc2_[this._info.ID][0])[1]);
            }
            else
            {
               this._iconPic.setFrame(12);
            }
         }
      }
      
      public function set ShowTips(param1:Boolean) : void
      {
         if(!param1)
         {
            ShowTipManager.Instance.removeTip(this);
         }
         else
         {
            ShowTipManager.Instance.addTip(this);
         }
      }
      
      public function setCusFrame(param1:int) : void
      {
         this._iconPic.setFrame(param1);
      }
      
      private function initView() : void
      {
         this._iconPic = ComponentFactory.Instance.creatComponentByStylename("militaryrank.Icon");
         addChild(this._iconPic);
      }
      
      public function get tipData() : Object
      {
         var _loc1_:String = null;
         var _loc2_:DictionaryData = TofflistModel.Instance.getMilitaryLocalTopN();
         if(this._score < ServerConfigManager.instance.getMilitaryData()[12] || !_loc2_.hasKey(this._info.ID))
         {
            _loc1_ = LanguageMgr.GetTranslation("tank.menu.MilitaryScore") + ":" + MilitaryRankManager.Instance.getMilitaryRankInfo(this._score).Name + "\n" + LanguageMgr.GetTranslation("tank.menu.MilitaryTxt") + ":" + this._score;
         }
         else
         {
            _loc1_ = LanguageMgr.GetTranslation("tank.menu.MilitaryScore") + ":" + MilitaryRankManager.Instance.getOtherMilitaryName(_loc2_[this._info.ID][0])[0] + "\n" + LanguageMgr.GetTranslation("tank.menu.MilitaryTxt") + ":" + this._score;
         }
         return _loc1_;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1 as String;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         this._tipDirctions = param1;
      }
      
      public function get tipGapH() : int
      {
         return 0;
      }
      
      public function set tipGapH(param1:int) : void
      {
      }
      
      public function get tipGapV() : int
      {
         return 0;
      }
      
      public function set tipGapV(param1:int) : void
      {
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(param1:String) : void
      {
         this._tipStyle = param1;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return null;
      }
      
      public function dispose() : void
      {
         if(this._info.ID == PlayerManager.Instance.Self.ID)
         {
            this.removeEventListener(MouseEvent.CLICK,this.__showMilitaryFrame);
         }
         ShowTipManager.Instance.removeTip(this);
         ObjectUtils.disposeObject(this._iconPic);
         this._iconPic = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
