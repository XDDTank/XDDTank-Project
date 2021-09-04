package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.ui.tip.ITip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import flash.geom.Point;
   
   public class FightToolBoxTip extends BaseTip implements Disposeable, ITip
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _level:FilterFrameText;
      
      private var _showMsg:FilterFrameText;
      
      private var _showMsgBg:Point;
      
      public function FightToolBoxTip()
      {
         super();
      }
      
      override public function get width() : Number
      {
         return this._bg.width;
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         var _loc2_:Date = null;
         var _loc3_:Date = null;
         var _loc4_:int = 0;
         if(param1)
         {
            if(param1 is SelfInfo)
            {
               _loc2_ = new Date(param1.fightVipStartTime.getTime() + param1.fightVipValidDate * 60 * 1000);
               _loc3_ = TimeManager.Instance.Now();
               if(!param1.isFightVip)
               {
                  this._showMsg.htmlText = LanguageMgr.GetTranslation("FightToolBoxFrame.vip.no");
               }
               else
               {
                  _loc4_ = Math.ceil((_loc2_.getTime() - _loc3_.getTime()) / 1000 / 60 / 60 / 24);
                  if(_loc4_ <= 0)
                  {
                     _loc4_ = 1;
                  }
                  this._showMsg.htmlText = LanguageMgr.GetTranslation("ddt.fightToolBox.iconTips",_loc4_);
               }
            }
            else
            {
               this._showMsg.htmlText = LanguageMgr.GetTranslation("ddt.fightToolBox.iconTipsOthers");
            }
            this._bg.width = this._showMsg.width + 15;
            this._bg.height = this._showMsg.height + 15;
         }
         else
         {
            this.visible = false;
         }
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
         this._level = ComponentFactory.Instance.creatComponentByStylename("fightToolBox.tips.level");
         this._showMsg = ComponentFactory.Instance.creatComponentByStylename("fightToolBox.tips.showMsg");
         this._showMsgBg = ComponentFactory.Instance.creatCustomObject("fightToolBox.tips.showMsgBg");
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._bg);
         addChild(this._level);
         addChild(this._showMsg);
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      override public function dispose() : void
      {
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(this._level)
         {
            ObjectUtils.disposeObject(this._level);
            this._level = null;
         }
         if(this._showMsg)
         {
            ObjectUtils.disposeObject(this._showMsg);
            this._showMsg = null;
         }
         if(this._showMsgBg)
         {
            ObjectUtils.disposeObject(this._showMsgBg);
            this._showMsgBg = null;
         }
      }
   }
}
