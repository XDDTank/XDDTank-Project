// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.ChatFacePanel

package ddt.view.chat
{
    import flash.display.Bitmap;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.BaseButton;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import ddt.manager.PathManager;
    import ddt.manager.LanguageMgr;
    import __AS3__.vec.*;

    public class ChatFacePanel extends ChatBasePanel 
    {

        private static const MAX_FACE_CNT:uint = 49;
        private static const COLUMN_LENGTH:uint = 10;
        private static const FACE_SPAN:uint = 25;

        protected var _bg:Bitmap;
        private var _faceBtns:Vector.<BaseButton> = new Vector.<BaseButton>();
        private var _inGame:Boolean;
        private var _selected:int;

        public function ChatFacePanel(_arg_1:Boolean=false)
        {
            this._inGame = _arg_1;
        }

        public function dispose():void
        {
            var _local_1:BaseButton;
            removeChild(this._bg);
            for each (_local_1 in this._faceBtns)
            {
                _local_1.dispose();
            };
            this._faceBtns = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function get selected():int
        {
            return (this._selected);
        }

        private function __itemClick(_arg_1:MouseEvent):void
        {
            var _local_2:String = (_arg_1.target as BaseButton).backStyle;
            SoundManager.instance.play("008");
            this._selected = int(_local_2.slice((_local_2.length - 2)));
            dispatchEvent(new Event(Event.SELECT));
        }

        protected function createBg():void
        {
            this._bg = ComponentFactory.Instance.creat("asset.chat.FacePanelBg");
            addChild(this._bg);
        }

        override protected function init():void
        {
            var _local_1:Point;
            var _local_2:uint;
            var _local_6:BaseButton;
            super.init();
            this.createBg();
            _local_1 = ComponentFactory.Instance.creatCustomObject("chat.FacePanelFacePos");
            _local_2 = 0;
            var _local_3:uint;
            var _local_4:Array = PathManager.solveChatFaceDisabledList();
            var _local_5:int = 1;
            while (_local_5 < MAX_FACE_CNT)
            {
                if (!((_local_4) && (_local_4.indexOf(String(_local_5)) > -1)))
                {
                    if (_local_3 == COLUMN_LENGTH)
                    {
                        _local_3 = 0;
                        _local_2++;
                    };
                    _local_6 = new BaseButton();
                    _local_6.beginChanges();
                    _local_6.backStyle = ("asset.chat.FaceBtn_" + ((_local_5 < 10) ? ("0" + String(_local_5)) : String(_local_5)));
                    _local_6.tipStyle = "core.ChatFaceTips";
                    _local_6.tipDirctions = "4";
                    _local_6.tipGapV = 5;
                    _local_6.tipGapH = -5;
                    _local_6.tipData = LanguageMgr.GetTranslation(("tank.view.chat.ChatFacePannel.face" + String(_local_5)));
                    _local_6.commitChanges();
                    _local_6.x = ((_local_3 * FACE_SPAN) + _local_1.x);
                    _local_6.y = ((_local_2 * FACE_SPAN) + _local_1.y);
                    _local_6.addEventListener(MouseEvent.CLICK, this.__itemClick);
                    this._faceBtns.push(_local_6);
                    addChild(_local_6);
                    _local_3++;
                };
                _local_5++;
            };
        }


    }
}//package ddt.view.chat

