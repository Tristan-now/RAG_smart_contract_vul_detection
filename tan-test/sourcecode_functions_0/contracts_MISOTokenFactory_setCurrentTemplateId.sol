function setCurrentTemplateId(uint256 _templateType, uint256 _templateId) external {
        require(
            accessControls.hasAdminRole(msg.sender) ||
            accessControls.hasOperatorRole(msg.sender),
            "MISOTokenFactory: Sender must be admin"
        );
        require(tokenTemplates[_templateId] != address(0), "MISOMarket: incorrect _templateId");
        require(IMisoToken(tokenTemplates[_templateId]).tokenTemplate() == _templateType, "MISOMarket: incorrect _templateType");
        currentTemplateId[_templateType] = _templateId;
    }