// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.cell.EquipLock

package bagAndInfo.cell
{
    import com.pickgliss.ui.core.Component;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;

    public class EquipLock extends Component 
    {

        private var _background:Bitmap;

        public function EquipLock()
        {
            this.initView();
        }

        private function initView():void
        {
            this._background = ComponentFactory.Instance.creatBitmap("assets.ddtbagAndInfo.equipLock");
            this._background.width = 52;
            this._background.height = 52;
            addChild(this._background);
        }

        public function gettipData(_arg_1:int):Object
        {
            if (_arg_1 == 0)
            {
                tipData = LanguageMgr.GetTranslation("ddt.bagAndInfo.LockCell.25tips");
            }
            else
            {
                if (_arg_1 == 1)
                {
                    tipData = LanguageMgr.GetTranslation("ddt.bagAndInfo.LockCell.30tips");
                }
                else
                {
                    if (_arg_1 == 2)
                    {
                        tipData = LanguageMgr.GetTranslation("ddt.bagAndInfo.LockCell.35tips");
                    }
                    else
                    {
                        if (((_arg_1 == 3) || (_arg_1 == 4)))
                        {
                            tipData = LanguageMgr.GetTranslation("ddt.bagAndInfo.LockCell.40tips");
                        };
                    };
                };
            };
            return (tipData);
        }


    }
}//package bagAndInfo.cell

