// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.view.WorldBossIcon

package worldboss.view
{
    import flash.display.Sprite;
    import flash.display.MovieClip;
    import com.pickgliss.loader.LoadResourceManager;
    import worldboss.WorldBossManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.LoaderEvent;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.SocketManager;
    import ddt.manager.ServerConfigManager;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import com.pickgliss.utils.ObjectUtils;

    public class WorldBossIcon extends Sprite 
    {

        private var _dragon:MovieClip;
        private var _isOpen:Boolean;

        public function WorldBossIcon(_arg_1:Boolean=false)
        {
            this._isOpen = _arg_1;
            this.init();
        }

        private function init():void
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(WorldBossManager.Instance.iconEnterPath, BaseLoader.MODULE_LOADER);
            _local_1.addEventListener(LoaderEvent.COMPLETE, this.onIconLoadedComplete);
            LoadResourceManager.instance.startLoad(_local_1);
        }

        private function onIconLoadedComplete(_arg_1:Event):void
        {
            this._dragon = ComponentFactory.Instance.creat(("asset.hall.worldBossEntrance-" + WorldBossManager.Instance.BossResourceId));
            this._dragon.mouseChildren = true;
            this._dragon.mouseEnabled = true;
            this._dragon.buttonMode = true;
            addChild(this._dragon);
            this._dragon.gotoAndStop(((this._isOpen) ? 1 : 2));
            this.addEvent();
            PositionUtils.setPos(this, "worldBoss.entranceIcon.pos");
        }

        private function addEvent():void
        {
            this._dragon.addEventListener(MouseEvent.CLICK, this.__enterBossRoom);
        }

        private function removeEvent():void
        {
            if (this._dragon)
            {
                this._dragon.removeEventListener(MouseEvent.CLICK, this.__enterBossRoom);
            };
        }

        private function __enterBossRoom(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("003");
            if (WorldBossManager.Instance.isOpen)
            {
                if (PlayerManager.Instance.checkExpedition())
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.expedition.doing"));
                }
                else
                {
                    SocketManager.Instance.out.enterWorldBossRoom();
                };
            }
            else
            {
                if (PlayerManager.Instance.Self.Grade < ServerConfigManager.instance.getWorldBossMinEnterLevel())
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("worldboss.minenterlevel", ServerConfigManager.instance.getWorldBossMinEnterLevel()));
                }
                else
                {
                    StateManager.setState(StateType.WORLDBOSS_AWARD);
                };
            };
        }

        public function setFrame(_arg_1:int):void
        {
            if (this._dragon)
            {
                this._dragon.gotoAndStop(_arg_1);
            };
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                this.parent.removeChild(this);
            };
            this._dragon = null;
        }


    }
}//package worldboss.view

