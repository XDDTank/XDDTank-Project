package worldboss.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import worldboss.WorldBossManager;
   
   public class WorldBossBuffItem extends Sprite implements Disposeable
   {
       
      
      private var _icon:Bitmap;
      
      private var _iconSprite:Sprite;
      
      private var _levelTxt:FilterFrameText;
      
      private var _tipBg:ScaleBitmapImage;
      
      private var _tipTitleTxt:FilterFrameText;
      
      private var _tipDescTxt:FilterFrameText;
      
      public function WorldBossBuffItem()
      {
         super();
         this.initView();
         this.updateInfo();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._icon = ComponentFactory.Instance.creatBitmap("worldBoss.attackBuff");
         this._iconSprite = new Sprite();
         this._iconSprite.addChild(this._icon);
         this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("worldBossRoom.buff.levelTxt");
         this._tipBg = ComponentFactory.Instance.creatComponentByStylename("worldBossRoom.newBuff.tipTxtBG");
         this._tipTitleTxt = ComponentFactory.Instance.creatComponentByStylename("worldBossRoom.buff.tipTxt.title");
         this._tipDescTxt = ComponentFactory.Instance.creatComponentByStylename("worldBossRoom.buff.tipTxt.desc");
         this.hideTip(null);
         addChild(this._iconSprite);
         addChild(this._levelTxt);
         addChild(this._tipBg);
         addChild(this._tipTitleTxt);
         addChild(this._tipDescTxt);
      }
      
      public function updateInfo() : void
      {
         var _loc1_:int = WorldBossManager.Instance.bossInfo.myPlayerVO.buffLevel;
         this._levelTxt.text = _loc1_.toString();
         var _loc2_:int = WorldBossManager.Instance.bossInfo.myPlayerVO.buffInjure;
         this._tipTitleTxt.text = LanguageMgr.GetTranslation("worldboss.buffIcon.tip.title",_loc2_);
         this._tipDescTxt.text = LanguageMgr.GetTranslation("worldboss.buffIcon.tip.desc",_loc2_);
         this.visible = _loc1_ != 0 ? Boolean(true) : Boolean(false);
      }
      
      private function addEvent() : void
      {
         this._iconSprite.addEventListener(MouseEvent.MOUSE_OVER,this.showTip);
         this._iconSprite.addEventListener(MouseEvent.MOUSE_OUT,this.hideTip);
         WorldBossManager.Instance.addEventListener(Event.CHANGE,this.__update);
      }
      
      protected function __update(param1:Event) : void
      {
         this.updateInfo();
      }
      
      private function showTip(param1:MouseEvent) : void
      {
         this._tipBg.visible = true;
         this._tipTitleTxt.visible = true;
         this._tipDescTxt.visible = true;
      }
      
      private function hideTip(param1:MouseEvent) : void
      {
         this._tipBg.visible = false;
         this._tipTitleTxt.visible = false;
         this._tipDescTxt.visible = false;
      }
      
      private function removeEvent() : void
      {
         this._iconSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.showTip);
         this._iconSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.hideTip);
         WorldBossManager.Instance.removeEventListener(Event.CHANGE,this.__update);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            this.parent.removeChild(this);
         }
         this._icon = null;
         this._levelTxt = null;
         this._tipBg = null;
         this._tipTitleTxt = null;
         this._tipDescTxt = null;
      }
   }
}
