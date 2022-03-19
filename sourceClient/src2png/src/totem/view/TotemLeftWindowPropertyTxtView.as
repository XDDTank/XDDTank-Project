// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//totem.view.TotemLeftWindowPropertyTxtView

package totem.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.text.FilterFrameText;
    import totem.data.TotemDataVo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import totem.TotemManager;
    import ddt.manager.PlayerManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class TotemLeftWindowPropertyTxtView extends Sprite implements Disposeable 
    {

        private var _levelTxtList:Vector.<FilterFrameText>;
        private var _txtArray:Array;
        private var _totemInfo:TotemDataVo;

        public function TotemLeftWindowPropertyTxtView()
        {
            this.mouseChildren = false;
            this.mouseEnabled = false;
            this._levelTxtList = new Vector.<FilterFrameText>();
            var _local_1:int = 1;
            while (_local_1 <= 7)
            {
                this._levelTxtList.push(ComponentFactory.Instance.creatComponentByStylename(("totem.totemWindow.propertyName" + _local_1)));
                _local_1++;
            };
            var _local_2:String = LanguageMgr.GetTranslation("ddt.totem.sevenProperty");
            this._txtArray = _local_2.split(",");
        }

        public function show(_arg_1:Array, _arg_2:TotemDataVo=null, _arg_3:int=0):void
        {
            this._totemInfo = _arg_2;
            var _local_4:int;
            while (_local_4 < 7)
            {
                this._levelTxtList[_local_4].x = (_arg_1[_local_4].x + 18);
                this._levelTxtList[_local_4].y = (_arg_1[_local_4].y + 81);
                this._levelTxtList[_local_4].text = (this._levelTxtList[_local_4].text + ("+" + TotemManager.instance.getAddValue((_local_4 + 1), TotemManager.instance.getAddInfo(this.getStopLv(this._totemInfo, _arg_3)))));
                addChild(this._levelTxtList[_local_4]);
                _local_4++;
            };
        }

        private function getStopLv(_arg_1:TotemDataVo, _arg_2:int):int
        {
            var _local_3:int;
            if (((_arg_1) && (_arg_1.Page == _arg_2)))
            {
                _local_3 = TotemManager.instance.getTotemPointLevel(PlayerManager.Instance.Self.totemId);
            }
            else
            {
                _local_3 = (_arg_2 * 70);
            };
            return (_local_3);
        }

        public function refreshLayer(_arg_1:int, _arg_2:TotemDataVo=null, _arg_3:int=0):void
        {
            this._totemInfo = _arg_2;
            var _local_4:Array = TotemManager.instance.getCurrentLvList(TotemManager.instance.getTotemPointLevel(PlayerManager.Instance.Self.totemId), _arg_3, this._totemInfo);
            var _local_5:int;
            while (_local_5 < 7)
            {
                this._levelTxtList[_local_5].text = LanguageMgr.GetTranslation("ddt.totem.totemWindow.propertyLvTxt", _local_4[_local_5], ((this._txtArray[_local_5] + "+") + TotemManager.instance.getAddValue((_local_5 + 1), TotemManager.instance.getAddInfo(this.getStopLv(this._totemInfo, _arg_3)))));
                _local_5++;
            };
        }

        public function scaleTxt(_arg_1:Number):void
        {
            if ((!(this._levelTxtList)))
            {
                return;
            };
            var _local_2:int = this._levelTxtList.length;
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                this._levelTxtList[_local_3].scaleX = _arg_1;
                this._levelTxtList[_local_3].scaleY = _arg_1;
                this._levelTxtList[_local_3].x = (this._levelTxtList[_local_3].x - 5);
                _local_3++;
            };
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            this._levelTxtList = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package totem.view

