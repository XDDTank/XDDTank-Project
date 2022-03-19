// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.view.WorldBossAwardOptionRightView

package worldboss.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.ScaleLeftRightImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PlayerManager;
    import ddt.events.PlayerPropertyEvent;
    import worldboss.WorldBossManager;
    import worldboss.event.WorldBossRoomEvent;
    import com.pickgliss.utils.ObjectUtils;

    public class WorldBossAwardOptionRightView extends Sprite implements Disposeable 
    {

        private var _ddtlittlegamebg:Bitmap;
        private var _listView:WorldBossAwardListView;
        private var _myPoint:Bitmap;
        private var _pointInputBg1:ScaleLeftRightImage;
        private var _pointTable:FilterFrameText;
        private var _pointTxt:FilterFrameText;
        private var _titlebg:Bitmap;

        public function WorldBossAwardOptionRightView()
        {
            this.initView();
            this.addEvent();
        }

        private function initView():void
        {
            this._ddtlittlegamebg = ComponentFactory.Instance.creatBitmap("ddtlittleGame.BG1");
            addChild(this._ddtlittlegamebg);
            this._pointInputBg1 = ComponentFactory.Instance.creatComponentByStylename("ddtlittleGameRightViewBG05");
            addChild(this._pointInputBg1);
            this._titlebg = ComponentFactory.Instance.creatBitmap("asset.worldbossAwardRoom.rightBg2");
            addChild(this._titlebg);
            this._myPoint = ComponentFactory.Instance.creatBitmap("asset.littleGame.myPoint");
            addChild(this._myPoint);
            this._pointTxt = ComponentFactory.Instance.creatComponentByStylename("littleGame.pointTxt");
            addChild(this._pointTxt);
            this._pointTxt.text = PlayerManager.Instance.Self.damageScores.toString();
            this._listView = ComponentFactory.Instance.creatCustomObject("worldbossAwardRoom.awardList");
            addChild(this._listView);
        }

        private function addEvent():void
        {
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.onChange);
            WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.ROOM_CLOSE, this.__roomclose);
        }

        private function onChange(_arg_1:PlayerPropertyEvent):void
        {
            this._pointTxt.text = PlayerManager.Instance.Self.damageScores.toString();
        }

        private function removeEvent():void
        {
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.onChange);
            WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.ROOM_CLOSE, this.__roomclose);
        }

        private function __roomclose(_arg_1:WorldBossRoomEvent):void
        {
            this._listView.updata();
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package worldboss.view

