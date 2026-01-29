//
//  ShareCardMessageCell.swift
//  Pods
//
//  Created by ERay on 2026/1/22.
//

protocol ShareCardMessageCellDelegate: MessageCellDelegate {
    func shareCardMessageCell(_ cell: ShareCardMessageCell, didTapWith cardConent: ShareCardMessageContent)
}

final class ShareCardMessageCell: MessageCell {

    override class var reuseId: String {
        String(describing: ShareCardMessageCell.self)
    }

    // MARK: - UI

    private lazy var cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10 * scaled
        view.clipsToBounds = true
        view.backgroundColor = UIColor(hex: "#191828")
        view.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        view.addGestureRecognizer(tap)
        return view
    }()

    private lazy var coverImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var borderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var bottomBgView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#191828")
        v.clipsToBounds = true
        return v
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14 * scaled, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .left
        return label
    }()

    private lazy var zodiacLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12 * scaled)
        label.textColor = UIColor(hex: "#C9C9C9")
        return label
    }()
    
    private lazy var priceIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = loadImageSafely(with: "ic_price_star")
        return iv
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16 * scaled, weight: .bold)
        label.textColor = UIColor(hex: "#C7A6FF")
        return label
    }()
    
    private lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#4B4B4B")
        return view
    }()

    private lazy var footerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 9 * scaled)
        label.textColor = UIColor(hex: "#A45DBA")
        label.text = L10n("message_from_card")
        label.textAlignment = .right
        return label
    }()

    // MARK: - Constraint

    private var cardWidthConstraint: NSLayoutConstraint!
    private var cardHeightConstraint: NSLayoutConstraint!

    // MARK: - Setup
    
    override func prepareForReuse() {
        super.prepareForReuse()

        coverImageView.kf.cancelDownloadTask()

        coverImageView.image = nil
        borderImageView.image = nil

        titleLabel.text = nil
        zodiacLabel.text = nil
        priceLabel.text = nil

        cardWidthConstraint.constant = 240 * scaled
        cardHeightConstraint.constant = 408 * scaled
    }

    override func setUp() {
        super.setUp()

        containerView.addSubview(cardView)
        cardView.addSubview(coverImageView)
        cardView.addSubview(borderImageView)
        cardView.addSubview(bottomBgView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(zodiacLabel)
        cardView.addSubview(priceIconImageView)
        cardView.addSubview(priceLabel)
        cardView.addSubview(line)
        cardView.addSubview(footerLabel)

        cardView.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        borderImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomBgView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        zodiacLabel.translatesAutoresizingMaskIntoConstraints = false
        priceIconImageView.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
        footerLabel.translatesAutoresizingMaskIntoConstraints = false

        cardWidthConstraint = cardView.widthAnchor.constraint(equalToConstant: 240 * scaled)
        cardHeightConstraint = cardView.heightAnchor.constraint(equalToConstant: 408 * scaled)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: containerView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            cardWidthConstraint,
            cardHeightConstraint,

            coverImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: 240 * scaled),
            
            borderImageView.topAnchor.constraint(equalTo: coverImageView.topAnchor),
            borderImageView.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            borderImageView.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
            borderImageView.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 20 * scaled),
            
            bottomBgView.topAnchor.constraint(equalTo: coverImageView.bottomAnchor),
            bottomBgView.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            bottomBgView.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
            bottomBgView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 12 * scaled),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10 * scaled),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10 * scaled),

            zodiacLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4 * scaled),
            zodiacLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            zodiacLabel.bottomAnchor.constraint(equalTo: line.topAnchor, constant: -10 * scaled),
            
            priceIconImageView.centerYAnchor.constraint(equalTo: zodiacLabel.centerYAnchor),
            priceIconImageView.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -4 * scaled),
            priceIconImageView.widthAnchor.constraint(equalToConstant: 21 * scaled),
            priceIconImageView.heightAnchor.constraint(equalToConstant: 21 * scaled),

            priceLabel.centerYAnchor.constraint(equalTo: zodiacLabel.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10 * scaled),
            
            line.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10 * scaled),
            line.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: 0.5 * scaled),

            footerLabel.topAnchor.constraint(greaterThanOrEqualTo: line.bottomAnchor, constant: 8 * scaled),
            footerLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8 * scaled),
            footerLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -15 * scaled)
        ])
    }

    // MARK: - Update

    override func updateContent() {
        super.updateContent()

        guard let vm = messageVM as? ShareCardMessageViewModel else { return }
        let content = vm.message.shareCardContent
        titleLabel.text = content.name
        zodiacLabel.text = Zodiac(rawValue: content.zodiacSign)?.fullString
        priceLabel.text = "\(content.price)"

        coverImageView.loadImage(with: content.cardUrl, placeholder: "avatar_default")
        borderImageView.image = content.boderImage

        cardWidthConstraint.constant = vm.contentMediaSize.width
        cardHeightConstraint.constant = vm.contentMediaSize.height
    }

    // MARK: - Action

    @objc private func cardTapped() {
        guard let vm = messageVM as? ShareCardMessageViewModel else { return }
        let delegate = delegate as? ShareCardMessageCellDelegate
        delegate?.shareCardMessageCell(self, didTapWith: vm.message.shareCardContent)
    }
}

enum Zodiac:Int, CaseIterable {
    case aries          // 牡羊座
    case taurus         // 金牛座
    case gemini         // 雙子座
    case cancer         // 巨蟹座
    case leo            // 獅子座
    case virgo          // 處女座
    case libra          // 天秤座
    case scorpio        // 天蠍座
    case sagittarius    // 射手座
    case capricorn      // 摩羯座
    case aquarius       // 水瓶座
    case pisces         // 雙魚座
    
    var fullString: String {
        switch self {
        case .aries:
            return L10n("aries_full")
        case .taurus:
            return L10n("taurus_full")
        case .gemini:
            return L10n("gemini_full")
        case .cancer:
            return L10n("cancer_full")
        case .leo:
            return L10n("leo_full")
        case .virgo:
            return L10n("virgo_full")
        case .libra:
            return L10n("libra_full")
        case .scorpio:
            return L10n("scorpio_full")
        case .sagittarius:
            return L10n("sagittarius_full")
        case .capricorn:
            return L10n("capricorn_full")
        case .aquarius:
            return L10n("aquarius_full")
        case .pisces:
            return L10n("pisces_full")
        }
    }
}
