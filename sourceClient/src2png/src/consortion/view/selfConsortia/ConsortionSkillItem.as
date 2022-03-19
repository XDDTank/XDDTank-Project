// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.ConsortionSkillItem

package consortion.view.selfConsortia
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import flash.display.DisplayObject;
    import __AS3__.vec.Vector;
    import consortion.data.ConsortionNewSkillInfo;
    import com.pickgliss.ui.controls.BaseButton;
    import flash.display.MovieClip;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import flash.events.MouseEvent;
    import consortion.ConsortionModelControl;
    import road7th.data.DictionaryData;
    import ddt.manager.PlayerManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class ConsortionSkillItem extends Sprite implements Disposeable 
    {

        private var _bg1:Bitmap;
        private var _bg2:ScaleBitmapImage;
        private var _cellBG1:DisplayObject;
        private var _cellBG2:DisplayObject;
        private var _sign:Bitmap;
        private var _level:int;
        private var _open:Boolean;
        private var _isMetal:Boolean;
        private var _cells:Vector.<ConsortionSkillCell>;
        private var _cellsBg:Vector.<Bitmap>;
        private var _currentInfo:ConsortionNewSkillInfo;
        private var _upgradeBtns:Vector.<BaseButton>;
        private var _shine:MovieClip;

        public function ConsortionSkillItem(_arg_1:int, _arg_2:Boolean, _arg_3:Boolean=false)
        {
            this._level = _arg_1;
            this._open = _arg_2;
            this._isMetal = _arg_3;
            this.initView();
        }

        private function initView():void
        {
            this._bg1 = ComponentFactory.Instance.creatBitmap("skillFrame.ItemBG1");
            this._bg2 = ComponentFactory.Instance.creatComponentByStylename("skillFrame.ItemBG2");
            this._cellBG1 = ComponentFactory.Instance.creatCustomObject("skillFrame.ItemCellBG1");
            this._cellBG2 = ComponentFactory.Instance.creatCustomObject("skillFrame.ItemCellBG2");
            this._sign = ComponentFactory.Instance.creatBitmap(("consortion.skillFrame.grade_" + this._level));
            PositionUtils.setPos(this._sign, "consortion.skillFrame.gradePos");
            addChild(this._bg1);
            addChild(this._sign);
            if ((!(this._open)))
            {
                filters = ComponentFactory.Instance.creatFilters("grayFilter");
            }
            else
            {
                filters = null;
            };
            this._cells = new Vector.<ConsortionSkillCell>();
            this._cellsBg = new Vector.<Bitmap>();
            this._upgradeBtns = new Vector.<BaseButton>();
        }

        public function set data(_arg_1:Vector.<ConsortionNewSkillInfo>):void
        {
            var _local_2:int;
            var _local_3:Bitmap;
            var _local_4:ConsortionSkillCell;
            var _local_5:BaseButton;
            _local_2 = 0;
            while (_local_2 < _arg_1.length)
            {
                _local_3 = ComponentFactory.Instance.creatBitmap("asset.consortion.SkillBg");
                _local_3.x = (132 + (_local_3.width * _local_2));
                _local_3.y = 6;
                addChild(_local_3);
                this._cellsBg.push(_local_3);
                _local_4 = new ConsortionSkillCell();
                _local_4.info = _arg_1[_local_2];
                _local_4.x = (147 + (_local_3.width * _local_2));
                _local_4.y = 13;
                addChild(_local_4);
                _local_5 = ComponentFactory.Instance.creatComponentByStylename("asset.consortion.SkillUpgradeBtn");
                addChild(_local_5);
                _local_5.x = (170 + (72 * _local_2));
                _local_5.y = 42;
                this._upgradeBtns.push(_local_5);
                this._upgradeBtns[_local_2].addEventListener(MouseEvent.CLICK, this.__upgrade);
                this._cells.push(_local_4);
                if ((!(this._open)))
                {
                    this._cells[_local_2].isLearn(false);
                    this._upgradeBtns[_local_2].visible = false;
                }
                else
                {
                    if (ConsortionModelControl.Instance.model.getisLearnByBuffId(_arg_1[_local_2].BuffID))
                    {
                        this._upgradeBtns[_local_2].visible = false;
                        this._cells[_local_2].isLearn(true);
                    }
                    else
                    {
                        if (ConsortionModelControl.Instance.model.getisUpgradeByBuffId(_arg_1[_local_2].BuffID))
                        {
                            this._upgradeBtns[_local_2].visible = false;
                            this._cells[_local_2].isLearn(true);
                        }
                        else
                        {
                            if (((!(_arg_1[_local_2].BuffID == 1)) && (!(ConsortionModelControl.Instance.model.getisLearnByBuffId((_arg_1[_local_2].BuffID - 1))))))
                            {
                                this._upgradeBtns[_local_2].visible = false;
                                this._cells[_local_2].isLearn(false);
                            }
                            else
                            {
                                this._upgradeBtns[_local_2].visible = true;
                                this._cells[_local_2].isLearn(false);
                            };
                        };
                    };
                };
                _local_2++;
            };
            this.setStatus();
        }

        private function setStatus():void
        {
            var _local_1:DictionaryData;
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            _local_1 = PlayerManager.Instance.Self.isLearnSkill;
            _local_2 = 0;
            while (_local_2 < this._cells.length)
            {
                _local_3 = PlayerManager.Instance.Self.isLearnSkill.length;
                if (this._cells[_local_2].info)
                {
                    _local_4 = 0;
                    while (_local_4 < _local_3)
                    {
                        if (this._cells[_local_2].info.BuffID == int(_local_1[_local_4]))
                        {
                            this._upgradeBtns[_local_2].visible = false;
                            if (((((_local_4 + 1) == _local_3) && (this._cells[_local_2].info.BuffID == int(_local_1[_local_4]))) && (ConsortionModelControl.Instance.model.shinePlay)))
                            {
                                if ((!(this._shine)))
                                {
                                    this._shine = ComponentFactory.Instance.creat("consortion.SkillView.skillItem.shine");
                                    addChild(this._shine);
                                    this._shine.x = (this._cells[_local_2].x - 12);
                                    this._shine.y = 4;
                                    this._shine.mouseChildren = false;
                                    this._shine.mouseEnabled = false;
                                };
                                this._shine.play();
                                ConsortionModelControl.Instance.model.shinePlay = false;
                            };
                        };
                        _local_4++;
                    };
                };
                _local_2++;
            };
        }

        private function __upgrade(_arg_1:MouseEvent):void
        {
            this._currentInfo = this._cells[this._upgradeBtns.indexOf((_arg_1.currentTarget as BaseButton))].info;
            SocketManager.Instance.out.sendConsortionSkill(this._currentInfo.BuffID);
        }

        override public function get height():Number
        {
            return (this._bg1.height);
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            var _local_1:int;
            while (_local_1 < this._cells.length)
            {
                this._cells[_local_1] = null;
                _local_1++;
            };
            var _local_2:int;
            while (_local_2 < this._upgradeBtns.length)
            {
                this._upgradeBtns[_local_1] = null;
                _local_2++;
            };
            this._bg1 = null;
            this._bg2 = null;
            this._cellBG1 = null;
            this._cellBG2 = null;
            this._sign = null;
            this._cells = null;
            this._upgradeBtns = null;
            this._shine = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia

