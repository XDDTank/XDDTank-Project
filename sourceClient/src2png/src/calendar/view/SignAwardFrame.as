// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//calendar.view.SignAwardFrame

package calendar.view
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import flash.display.DisplayObject;
    import __AS3__.vec.Vector;
    import ddt.manager.SoundManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.data.DaylyGiveInfo;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import ddt.manager.ItemManager;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import __AS3__.vec.*;

    public class SignAwardFrame extends BaseAlerFrame 
    {

        private var _back:DisplayObject;
        private var _awardCells:Vector.<SignAwardCell> = new Vector.<SignAwardCell>();
        private var _awards:Array;
        private var _signCount:int;

        public function SignAwardFrame()
        {
            this.configUI();
        }

        private function __response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            removeEventListener(FrameEvent.RESPONSE, this.__response);
            ObjectUtils.disposeObject(this);
        }

        public function show(_arg_1:int, _arg_2:Array):void
        {
            var _local_4:int;
            var _local_6:DaylyGiveInfo;
            var _local_7:SignAwardCell;
            this._signCount = _arg_1;
            this._awards = _arg_2;
            var _local_3:Point = ComponentFactory.Instance.creatCustomObject("Calendar.SignAward.TopLeft");
            _local_4 = 0;
            var _local_5:int;
            for each (_local_6 in this._awards)
            {
                _local_7 = ComponentFactory.Instance.creatCustomObject("SignAwardCell");
                this._awardCells.push(_local_7);
                _local_7.info = ItemManager.Instance.getTemplateById(_local_6.TemplateID);
                _local_7.setCount(_local_6.Count);
                if ((_local_5 % 2) == 0)
                {
                    _local_7.x = _local_3.x;
                    _local_7.y = (_local_3.y + (_local_4 * 64));
                }
                else
                {
                    _local_7.x = (_local_3.x + 139);
                    _local_7.y = (_local_3.y + (_local_4 * 64));
                    _local_4++;
                };
                addToContent(_local_7);
                _local_5++;
            };
            addEventListener(FrameEvent.RESPONSE, this.__response);
        }

        private function configUI():void
        {
            info = new AlertInfo(LanguageMgr.GetTranslation("tank.calendar.sign.title"), LanguageMgr.GetTranslation("ok"), "", true, false);
            this._back = ComponentFactory.Instance.creatComponentByStylename("Calendar.SignAward.Back");
            addToContent(this._back);
        }

        override public function dispose():void
        {
            while (this._awardCells.length > 0)
            {
                ObjectUtils.disposeObject(this._awardCells.shift());
            };
            ObjectUtils.disposeObject(this._back);
            this._back = null;
            super.dispose();
        }


    }
}//package calendar.view

