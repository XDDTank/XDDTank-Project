// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.MarriedTip

package ddt.view.tips
{
    import flash.text.TextFormat;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.geom.Point;

    public class MarriedTip extends OneLineTip 
    {

        private var _nickNameTF:TextFormat;


        override protected function init():void
        {
            _bg = ComponentFactory.Instance.creatComponentByStylename("core.MarriedTipBg");
            _contentTxt = ComponentFactory.Instance.creatComponentByStylename("core.commonTipText");
            this._nickNameTF = ComponentFactory.Instance.model.getSet("core.MarriedTipNickNameTF");
            addChild(_bg);
            addChild(_contentTxt);
        }

        override public function set tipData(_arg_1:Object):void
        {
            if (_arg_1 != _data)
            {
                _data = _arg_1;
                _contentTxt.text = LanguageMgr.GetTranslation(("core.MarriedTipLatterText" + String(((_data.gender) ? "Husband" : "Wife"))), _data.nickName);
                _contentTxt.setTextFormat(this._nickNameTF, 0, (_contentTxt.length - 3));
                updateTransform();
            };
        }

        private function fitTextWidth():void
        {
            var _local_3:String;
            var _local_4:int;
            var _local_1:Point = localToGlobal(new Point(0, 0));
            var _local_2:int = ((_local_1.x + width) - 1000);
            if (_local_2 > 0)
            {
                _local_3 = _contentTxt.text;
                _contentTxt.text = _local_3.substring(0, (_local_3.length - 3));
                _local_4 = _contentTxt.getCharIndexAtPoint(((_contentTxt.width - _local_2) - 20), 5);
                _contentTxt.text = ((_contentTxt.text.substring(0, _local_4) + "...") + _local_3.substr((_local_3.length - 3)));
            };
            _contentTxt.setTextFormat(this._nickNameTF, 0, (_contentTxt.length - 3));
            updateTransform();
        }

        override public function set x(_arg_1:Number):void
        {
            super.x = _arg_1;
            this.fitTextWidth();
        }


    }
}//package ddt.view.tips

