// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.regFunc

package cmodule.decry
{
    public function regFunc(_arg_1:Function):int
    {
        return (gstate.funcs.push(_arg_1) - 1);
    }

}//package cmodule.decry

