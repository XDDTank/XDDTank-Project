package worldboss.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import worldboss.WorldBossManager;
   
   public class WorldBossBuffIcon extends Sprite implements Disposeable
   {
       
      
      private var _moneyBtn:SimpleBitmapButton;
      
      private var _bindMoneyBtn:SimpleBitmapButton;
      
      private var _buffIcon:WorldBossBuffItem;
      
      public function WorldBossBuffIcon()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:int = WorldBossManager.Instance.bossInfo.addInjureBuffMoney;
         var _loc2_:int = WorldBossManager.Instance.bossInfo.addInjureValue;
         this._moneyBtn = ComponentFactory.Instance.creat("worldbossRoom.money.buffBtn");
         this._bindMoneyBtn = ComponentFactory.Instance.creat("worldbossRoom.bindMoney.buffBtn");
         this._moneyBtn.tipData = LanguageMgr.GetTranslation("worldboss.money.buffBtn.tip",_loc1_,_loc2_);
         this._buffIcon = new WorldBossBuffItem();
         PositionUtils.setPos(this._buffIcon,"worldboss.RoomView.BuffIconPos");
         addChild(this._moneyBtn);
         addChild(this._buffIcon);
      }
      
      private function addEvent() : void
      {
         this._moneyBtn.addEventListener(MouseEvent.CLICK,this.buyBuff);
      }
      
      private function buyBuff(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.playButtonSound();
         if(param1.currentTarget == this._moneyBtn)
         {
            _loc2_ = 1;
         }
         else
         {
            _loc2_ = 2;
         }
         if(SharedManager.Instance.isWorldBossBuyBuff)
         {
            WorldBossManager.Instance.buyNewBuff();
            return;
         }
         var _loc3_:WorldBossBuyBuffConfirmFrame = ComponentFactory.Instance.creatComponentByStylename("worldboss.buyBuff.confirmFrame");
         _loc3_.show(_loc2_);
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:WorldBossBuyBuffConfirmFrame = param1.currentTarget as WorldBossBuyBuffConfirmFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
         }
      }
      
      private function removeEvent() : void
      {
         this._moneyBtn.removeEventListener(MouseEvent.CLICK,this.buyBuff);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            this.parent.removeChild(this);
         }
         this._moneyBtn = null;
         this._bindMoneyBtn = null;
         this._buffIcon = null;
      }
   }
}
