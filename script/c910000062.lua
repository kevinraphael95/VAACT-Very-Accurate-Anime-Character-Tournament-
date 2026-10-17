--[VAACT] Cercle Envoûtant
local s,id=GetID()
local CERCLE_ID = 910000062

function s.initial_effect(c)
	-- Traité comme Spellbinding Circle officiel (ID 81385346)
	local e_add = Effect.CreateEffect(c)
	e_add:SetType(EFFECT_TYPE_SINGLE)
	e_add:SetCode(EFFECT_ADD_CODE)
	e_add:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add:SetValue(81385346)
	c:RegisterEffect(e_add)

	-- Activation de la carte (Piège Continu)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	-- Effet : Ne peut pas attaquer
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(s.atktg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)

	-- Effet : Ne peut pas changer de position de combat
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(s.postg)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	
	-- Effet : Perd 700 ATK
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(s.atktg)
	e4:SetValue(-700)
	e4:SetLabelObject(e1)
	c:RegisterEffect(e4)
	
	-- Effet : Si la cible est détruite, détruire cette carte
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetOperation(s.checkop)
	c:RegisterEffect(e5)
	
	e1:SetLabelObject(e5)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		c:SetCardTarget(tc)
		
		local e5=e:GetLabelObject()
		if e5 then
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetCode(EFFECT_DESTROY_REPLACE)
			e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e6:SetTarget(s.reptg)
			e6:SetOperation(s.repop)
			e6:SetLabelObject(tc)
			e6:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e6)
		end
	end
end

function s.atktg(e,c)
	local tc=e:GetLabelObject():GetLabelObject():GetFirstCardTarget()
	return tc and c==tc
end

function s.postg(e,c)
	local tc=e:GetLabelObject():GetLabelObject():GetFirstCardTarget()
	return tc and c==tc
end

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetFirstCardTarget()
	if tc then
		if tc:IsReason(REASON_DESTROY) then
			Duel.Destroy(c, REASON_EFFECT)
		end
	end
end

function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	return true
end

function s.repop(e,tp,eg,ep,ev,re,r,rp)
end