// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.view.WorldBossBuffItem

package worldboss.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.ComponentFactory;
    import worldboss.WorldBossManager;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;

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
            this.initView();
            this.updateInfo();
            this.addEvent();
        }

        private function initView():void
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

        public function updateInfo():void
        {
            var _local_1:int = WorldBossManager.Instance.bossInfo.myPlayerVO.buffLevel;
            this._levelTxt.text = _local_1.toString();
            var _local_2:int = WorldBossManager.Instance.bossInfo.myPlayerVO.buffInjure;
            this._tipTitleTxt.text = LanguageMgr.GetTranslation("worldboss.buffIcon.tip.title", _local_2);
            this._tipDescTxt.text = LanguageMgr.GetTranslation("worldboss.buffIcon.tip.desc", _local_2);
            this.visible = ((!(_local_1 == 0)) ? true : false);
        }

        private function addEvent():void
        {
            this._iconSprite.addEventListener(MouseEvent.MOUSE_OVER, this.showTip);
            this._iconSprite.addEventListener(MouseEvent.MOUSE_OUT, this.hideTip);
            WorldBossManager.Instance.addEventListener(Event.CHANGE, this.__update);
        }

        protected function __update(_arg_1:Event):void
        {
            this.updateInfo();
        }

        private function showTip(_arg_1:MouseEvent):void
        {
            this._tipBg.visible = true;
            this._tipTitleTxt.visible = true;
            this._tipDescTxt.visible = true;
        }

        private function hideTip(_arg_1:MouseEvent):void
        {
            this._tipBg.visible = false;
            this._tipTitleTxt.visible = false;
            this._tipDescTxt.visible = false;
        }

        private function removeEvent():void
        {
            this._iconSprite.removeEventListener(MouseEvent.MOUSE_OVER, this.showTip);
            this._iconSprite.removeEventListener(MouseEvent.MOUSE_OUT, this.hideTip);
            WorldBossManager.Instance.removeEventListener(Event.CHANGE, this.__update);
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                this.parent.removeChild(this);
            };
            this._icon = null;
            this._levelTxt = null;
            this._tipBg = null;
            this._tipTitleTxt = null;
            this._tipDescTxt = null;
        }


    }
}//package worldboss.view

