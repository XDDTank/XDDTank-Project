package game.view.control
{
   import com.greensock.TweenMax;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.GameEvent;
   import ddt.events.SharedEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import game.model.LocalPlayer;
   
   public class MouseControlBar extends Sprite implements Disposeable
   {
       
      
      protected var _btnBg:Bitmap;
      
      private var _leftBtn:SelectedButton;
      
      private var _rightBtn:SelectedButton;
      
      private var _self:LocalPlayer;
      
      private var _state:Boolean = false;
      
      private var _moveLead:MovieClip;
      
      public function MouseControlBar(param1:LocalPlayer)
      {
         super();
         this._self = param1;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._btnBg = ComponentFactory.Instance.creatBitmap("asset.game.mouseState.BtnBg.png");
         addChild(this._btnBg);
         this._rightBtn = ComponentFactory.Instance.creatComponentByStylename("game.mouseState.rightBtn");
         this.setTip(this._rightBtn,LanguageMgr.GetTranslation("ddt.game.mouseControlBar.btntips.right"));
         addChild(this._rightBtn);
         this._leftBtn = ComponentFactory.Instance.creatComponentByStylename("game.mouseState.leftBtn");
         this.setTip(this._leftBtn,LanguageMgr.GetTranslation("ddt.game.mouseControlBar.btntips.left"));
         addChild(this._leftBtn);
         this.__transparentChanged(null);
      }
      
      public function showLead() : void
      {
         if(!this._moveLead)
         {
            this._moveLead = ComponentFactory.Instance.creat("asset.game.mouseState.lead.move") as MovieClip;
            this._moveLead.mouseChildren = false;
            this._moveLead.mouseEnabled = false;
            PositionUtils.setPos(this._moveLead,"asset.game.mouseState.moveLeadPos");
            addChild(this._moveLead);
         }
      }
      
      private function setTip(param1:SelectedButton, param2:String) : void
      {
         param1.tipStyle = "ddt.view.tips.OneLineTip";
         param1.tipDirctions = "0";
         param1.tipGapV = 5;
         param1.tipData = param2;
      }
      
      public function set state(param1:Boolean) : void
      {
         this._state = param1;
         this.visible = this._state;
      }
      
      private function __mouseDownLeft(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._leftBtn.selected = true;
         if(this._self.isLiving && !this._self.isAttacking)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.ArrowViewIII.fall"));
            return;
         }
         this._self.dispatchEvent(new GameEvent(GameEvent.MOUSE_DOWN_LEFT));
         if(this._moveLead)
         {
            ObjectUtils.disposeObject(this._moveLead);
            this._moveLead = null;
         }
      }
      
      private function __mouseUpLeft(param1:MouseEvent) : void
      {
         this._self.dispatchEvent(new GameEvent(GameEvent.MOUSE_UP_LEFT));
         this._leftBtn.selected = false;
      }
      
      private function __mouseUpRight(param1:MouseEvent) : void
      {
         this._self.dispatchEvent(new GameEvent(GameEvent.MOUSE_UP_Right));
         this._rightBtn.selected = false;
      }
      
      private function __mouseDownRight(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._rightBtn.selected = true;
         if(this._self.isLiving && !this._self.isAttacking)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.ArrowViewIII.fall"));
            return;
         }
         this._self.dispatchEvent(new GameEvent(GameEvent.MOUSE_DOWN_Right));
         if(this._moveLead)
         {
            ObjectUtils.disposeObject(this._moveLead);
            this._moveLead = null;
         }
      }
      
      private function __transparentChanged(param1:SharedEvent) : void
      {
         if(SharedManager.Instance.propTransparent)
         {
            this.alpha = 0.5;
         }
         else
         {
            this.alpha = 1;
         }
      }
      
      private function __mouseOver(param1:MouseEvent) : void
      {
         var _loc2_:SelectedButton = param1.target as SelectedButton;
         TweenMax.to(_loc2_,0.1,{"glowFilter":{
            "color":16777203,
            "alpha":1,
            "blurX":8,
            "blurY":8,
            "strength":1
         }});
      }
      
      private function __mouseOut(param1:MouseEvent) : void
      {
         var _loc2_:SelectedButton = param1.target as SelectedButton;
         TweenMax.killChildTweensOf(_loc2_.parent);
         _loc2_.filters = null;
      }
      
      private function initEvent() : void
      {
         this._leftBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.__mouseDownLeft);
         this._leftBtn.addEventListener(MouseEvent.MOUSE_UP,this.__mouseUpLeft);
         this._leftBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__mouseUpLeft);
         this._leftBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         this._leftBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
         this._rightBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.__mouseDownRight);
         this._rightBtn.addEventListener(MouseEvent.MOUSE_UP,this.__mouseUpRight);
         this._rightBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__mouseUpLeft);
         this._rightBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         this._rightBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
         SharedManager.Instance.addEventListener(SharedEvent.TRANSPARENTCHANGED,this.__transparentChanged);
      }
      
      private function removeEvent() : void
      {
         this._leftBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.__mouseDownLeft);
         this._leftBtn.removeEventListener(MouseEvent.MOUSE_UP,this.__mouseUpLeft);
         this._leftBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseUpLeft);
         this._leftBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         this._leftBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
         this._rightBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.__mouseDownRight);
         this._rightBtn.removeEventListener(MouseEvent.MOUSE_UP,this.__mouseUpRight);
         this._rightBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseUpLeft);
         this._rightBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         this._rightBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
         SharedManager.Instance.removeEventListener(SharedEvent.TRANSPARENTCHANGED,this.__transparentChanged);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._btnBg);
         this._btnBg = null;
         ObjectUtils.disposeObject(this._leftBtn);
         this._leftBtn = null;
         ObjectUtils.disposeObject(this._rightBtn);
         this._rightBtn = null;
      }
   }
}
